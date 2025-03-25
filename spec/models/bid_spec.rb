require 'rails_helper'

RSpec.describe Bid, type: :model do
  let(:seller) { create(:user) }
  let(:buyer) { create(:user) }
  let(:auction) { create(:auction, seller: seller, starting_price: 100) }

  describe 'associations' do
    it 'is valid if the amount is greater than the current price' do
      bid = build(:bid, auction: auction, buyer: buyer, amount: 200)
      expect(bid).to be_valid
    end

    it 'is invalid if the amount is less than or equal to the current price' do
      bid = build(:bid, auction: auction, buyer: buyer, amount: 90)
      expect(bid).to be_invalid
      expect(bid.errors[:amount]).to include('must be greater than the current price')
    end
  end

  describe 'validations' do
    it { is_expected.to validate_presence_of(:amount) }
    it { is_expected.to validate_numericality_of(:amount).is_greater_than(0) }

    context 'when validating amount against current price' do
      it 'is valid if the amount is greater than the current price' do
        auction.update(current_price: 150)
        bid = build(:bid, auction: auction, buyer: buyer, amount: 200)
        expect(bid).to be_valid
      end

      it 'is invalid if the amount is less than or equal to the current price' do
        auction.update(current_price: 150)
        bid = build(:bid, auction: auction, buyer: buyer, amount: 150)
        expect(bid).to be_invalid
        expect(bid.errors[:amount]).to include('must be greater than the current price')
      end

      it 'is valid if the amount is greater than the starting price when no current price exists' do
        auction.update(current_price: nil)
        bid = build(:bid, auction: auction, buyer: buyer, amount: 120)
        expect(bid).to be_valid
      end

      it 'is invalid if the amount is less than or equal to the starting price when no current price exists' do
        auction.update(current_price: nil)
        bid = build(:bid, auction: auction, buyer: buyer, amount: 100)
        expect(bid).to be_invalid
        expect(bid.errors[:amount]).to include('must be greater than the current price')
      end
    end
  end
end
