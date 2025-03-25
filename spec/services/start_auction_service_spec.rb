require 'rails_helper'

RSpec.describe StartAuctionService, type: :service do
  let(:seller) { create(:user, role: 'SELLER') }
  let(:auction) { create(:auction, seller: seller, status: 'INACTIVE', duration: 60) }

  describe '#call' do
    context 'when the auction is successfully started' do
      it 'updates the auction status to ACTIVE' do
        service = StartAuctionService.new(auction: auction)
        service.call

        auction.reload
        expect(auction.status).to eq('ACTIVE')
      end

      it 'sets the auction start_time to the current time' do
        service = StartAuctionService.new(auction: auction)
        service.call

        auction.reload
        expect(auction.start_time).to be_within(1.second).of(Time.zone.now)
      end

      it 'broadcasts the auction_started event to the active_auctions channel' do
        expect(ActionCable.server).to receive(:broadcast).with(
          "active_auctions",
          { event: "auction_started", auction_id: auction.id }
        )

        service = StartAuctionService.new(auction: auction)
        service.call
      end

      it 'returns true' do
        service = StartAuctionService.new(auction: auction)
        result = service.call

        expect(result).to be true
      end
    end

    context 'when the auction fails to save' do
      before do
        allow(auction).to receive(:save).and_return(false)
      end

      it 'does not broadcast any events' do
        expect(ActionCable.server).not_to receive(:broadcast)

        service = StartAuctionService.new(auction: auction)
        service.call
      end

      it 'does not schedule the CloseAuctionJob' do
        expect(CloseAuctionJob).not_to receive(:set)

        service = StartAuctionService.new(auction: auction)
        service.call
      end

      it 'returns nil' do
        service = StartAuctionService.new(auction: auction)
        result = service.call

        expect(result).to be_nil
      end
    end
  end
end
