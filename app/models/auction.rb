class Auction < ApplicationRecord
  belongs_to :seller, class_name: 'User'
  has_many :bids, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :starting_price, presence: true, numericality: { greater_than: 0 }
  validates :current_price, numericality: { greater_than: 0 }, allow_nil: true
  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :status, presence: true, inclusion: { in: %w[INACTIVE ACTIVE ENDED] }
end
