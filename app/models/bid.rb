class Bid < ApplicationRecord
  belongs_to :auction
  belongs_to :buyer, class_name: 'User'

  validates :amount, presence: true, numericality: { greater_than: 0 }
  validates :status, presence: true, inclusion: { in: %w[BIDDING WON LOST] }
end
