require 'rails_helper'

RSpec.describe MakeBidService, type: :service do
  let(:seller) { create(:user, role: 'SELLER') }
  let(:buyer) { create(:user, role: 'BUYER') }
  let(:auction) { create(:auction, seller: seller, starting_price: 100, status: 'ACTIVE') }
  let(:bid_params) { { amount: 150 } }

  describe '#call' do
    context 'when the bid is valid' do
      it 'creates a new bid' do
        service = MakeBidService.new(bid_params: bid_params, bidder: buyer, auction: auction)
        result = service.call

        expect(result).to be_persisted
        expect(result.amount).to eq(150)
        expect(result.buyer).to eq(buyer)
        expect(result.auction).to eq(auction)
      end

      it 'updates the auction current_price and status' do
        service = MakeBidService.new(bid_params: bid_params, bidder: buyer, auction: auction)
        service.call

        auction.reload
        expect(auction.current_price).to eq(150)
        expect(auction.status).to eq('BIDDING')
      end

      it 'broadcasts the bid creation to the appropriate channels' do
        expect(ActionCable.server).to receive(:broadcast).with("auction_#{auction.id}", hash_including(highest_bid: 150, bidder: buyer.name))
        expect(ActionCable.server).to receive(:broadcast).with("buyer_#{buyer.id}", hash_including(event: "bid_placed", auction_id: auction.id, amount: 150))
        expect(ActionCable.server).to receive(:broadcast).with("seller_#{seller.id}", hash_including(event: "new_bid", auction_id: auction.id, highest_bid: 150))

        service = MakeBidService.new(bid_params: bid_params, bidder: buyer, auction: auction)
        service.call
      end
    end

    context 'when the bid is invalid' do
      let(:bid_params) { { amount: 50 } } # Invalid because it's less than the starting price

      it 'does not create a new bid' do
        service = MakeBidService.new(bid_params: bid_params, bidder: buyer, auction: auction)
        result = service.call

        expect(result).not_to be_persisted
        expect(result.errors[:amount]).to include('must be greater than the current price')
      end

      it 'does not update the auction current_price or status' do
        service = MakeBidService.new(bid_params: bid_params, bidder: buyer, auction: auction)
        service.call

        auction.reload
        expect(auction.current_price).to be_nil
        expect(auction.status).to eq('ACTIVE')
      end

      it 'does not broadcast any events' do
        expect(ActionCable.server).not_to receive(:broadcast)

        service = MakeBidService.new(bid_params: bid_params, bidder: buyer, auction: auction)
        service.call
      end
    end
  end
end
