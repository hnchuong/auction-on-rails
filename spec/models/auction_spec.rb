require 'rails_helper'

RSpec.describe Auction, type: :model do
  let(:seller) { create(:user) }
  let(:buyer) { create(:user) }
  let(:buyer2) { create(:user) }
  let(:auction) { create(:auction, seller: seller) }
  let(:bid1) { create(:bid, auction: auction, buyer: buyer, amount: 100) }
  let(:bid2) { create(:bid, auction: auction, buyer: buyer2, amount: 200) }

  describe 'associations' do
    it 'belongs to a seller' do
      expect(auction).to belong_to(:seller).class_name('User')
    end

    it 'has many bids with dependent destroy' do
      expect(auction).to have_many(:bids).dependent(:destroy)
    end
  end

  describe 'validations' do
    it 'validates presence of title' do
      expect(auction).to validate_presence_of(:title)
    end

    it 'validates presence of starting_price' do
      expect(auction).to validate_presence_of(:starting_price)
    end

    it 'validates numericality of starting_price greater than 0' do
      expect(auction).to validate_numericality_of(:starting_price).is_greater_than(0)
    end

    it 'validates numericality of duration greater than 0' do
      expect(auction).to validate_numericality_of(:duration).is_greater_than(0)
    end

    it 'validates inclusion of status in allowed values' do
      expect(auction).to validate_inclusion_of(:status).in_array(%w[INACTIVE ACTIVE BIDDING CLOSED])
    end
  end

  describe 'scopes' do
    describe '.active' do
      it 'returns auctions with ACTIVE or BIDDING status' do
        active_auction = create(:auction, status: 'ACTIVE')
        bidding_auction = create(:auction, status: 'BIDDING')
        inactive_auction = create(:auction, status: 'INACTIVE')

        expect(Auction.active).to include(active_auction, bidding_auction)
        expect(Auction.active).not_to include(inactive_auction)
      end
    end
  end

  describe 'instance methods' do
    describe '#inactive?' do
      it 'returns true if the auction status is INACTIVE' do
        auction.update(status: 'INACTIVE')
        expect(auction.inactive?).to be true
      end
    end

    describe '#active?' do
      it 'returns true if the auction status is ACTIVE' do
        auction.update(status: 'ACTIVE')
        expect(auction.active?).to be true
      end
    end

    describe '#bidding?' do
      it 'returns true if the auction status is BIDDING' do
        auction.update(status: 'BIDDING')
        expect(auction.bidding?).to be true
      end
    end

    describe '#closed?' do
      it 'returns true if the auction status is CLOSED' do
        auction.update(status: 'CLOSED')
        expect(auction.closed?).to be true
      end
    end

    describe '#highest_bid' do
      it 'returns the highest bid for the auction' do
        bid1
        bid2
        expect(auction.highest_bid).to eq(bid2)
      end
    end

    describe '#on_bid?' do
      it 'returns true if the user is the highest bidder' do
        bid1
        expect(auction.on_bid?(buyer)).to be true
      end
    end

    describe '#out_bid?' do
      it 'returns true if the user is not the highest bidder' do
        bid2
        # another_user = create(:user)
        expect(auction.out_bid?(buyer)).to be true
      end
    end

    describe '#no_bid?' do
      it 'returns true if the user has not placed any bids' do
        another_user = create(:user)
        expect(auction.no_bid?(another_user)).to be true
      end
    end
  end
end