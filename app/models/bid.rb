class Bid < ApplicationRecord
  belongs_to :auction
  belongs_to :buyer, class_name: 'User'

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :auction, :buyer, presence: true

  validates_each :amount do |record, attr, value|
    next if record.auction.nil?

    current_price = record.auction.current_price || record.auction.starting_price
    record.errors.add(attr, 'must be greater than the current price') if value <= current_price
  end
end
