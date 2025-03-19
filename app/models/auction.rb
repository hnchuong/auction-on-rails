class Auction < ApplicationRecord
  belongs_to :seller, class_name: 'User'
  has_many :bids, dependent: :destroy

  validates :title, presence: true
  validates :starting_price, presence: true, numericality: { greater_than: 0 }
  validates :current_price, numericality: { greater_than: :starting_price }, allow_nil: true
  validates :duration, presence: true, numericality: { greater_than: 0 }
  validates :status, inclusion: { in: %w[INACTIVE ACTIVE BIDDING CLOSED] }

  scope :active, -> { where(status: %w(ACTIVE BIDDING)) }


  def inactive?
    status == 'INACTIVE'
  end

  def active?
    status == 'ACTIVE'
  end

  def bidding?
    status == 'BIDDING'
  end

  def closed?
    status == 'CLOSED'
  end

  def highest_bid
    bids.order(amount: :desc).first
  end

  def on_bid?(user)
    highest_bid&.buyer == user
  end

  def out_bid?(user)
    highest_bid&.buyer || user != user
  end

  def no_bid?(user)
    bids.where(buyer: user).empty?
  end
end
