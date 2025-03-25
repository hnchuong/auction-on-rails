require 'rails_helper'

RSpec.describe User, type: :model do
  let(:buyer) { create(:user, role: 'BUYER') }
  let(:seller) { create(:user, role: 'SELLER') }
  let(:auction) { create(:auction, seller: seller) }
  let(:bid) { create(:bid, auction: auction, buyer: buyer); auction.update(current_price: 100) }

  describe 'associations' do
    it { is_expected.to have_many(:sessions).dependent(:destroy) }
    it { is_expected.to have_many(:auctions).with_foreign_key(:seller_id).dependent(:destroy) }
    it { is_expected.to have_many(:bids).with_foreign_key(:buyer_id).dependent(:destroy) }
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:name) }
    it { is_expected.to validate_presence_of(:email_address) }
    it 'validates uniqueness of email_address' do
      create(:user, email_address: 'test@example.com') # Create a valid existing record
      expect(subject).to validate_uniqueness_of(:email_address).case_insensitive
    end
    it { is_expected.to validate_presence_of(:role) }
    it { is_expected.to validate_inclusion_of(:role).in_array(%w[BUYER SELLER]) }
  end

  describe '#bidding_auctions' do
    it 'returns auctions the user has placed bids on' do
      bid # Create a bid
      expect(buyer.reload.bidding_auctions).to include(auction)
    end

    it 'does not return auctions the user has not placed bids on' do
      expect(buyer.bidding_auctions).not_to include(auction)
    end
  end

  describe '#on_bid?' do
    it 'returns true if the user has placed a bid on the auction' do
      bid # Create a bid
      expect(buyer.on_bid?(auction)).to be true
    end

    it 'returns false if the user has not placed a bid on the auction' do
      expect(buyer.on_bid?(auction)).to be false
    end
  end

  describe '#buyer?' do
    it 'returns true if the user role is BUYER' do
      expect(buyer.buyer?).to be true
    end

    it 'returns false if the user role is not BUYER' do
      expect(seller.buyer?).to be false
    end
  end

  describe '#seller?' do
    it 'returns true if the user role is SELLER' do
      expect(seller.seller?).to be true
    end

    it 'returns false if the user role is not SELLER' do
      expect(buyer.seller?).to be false
    end
  end
end
