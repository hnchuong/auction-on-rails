class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w[BUYER SELLER] }

  has_many :auctions, foreign_key: :seller_id, dependent: :destroy
  has_many :bids, dependent: :destroy, foreign_key: :buyer_id

  def bidding_auctions
    Auction.joins(:bids).where(bids: { buyer_id: id }).distinct
  end

  def on_bid?(auction)
    auction.bids.where(buyer_id: self.id).present?
  end

  def buyer?
    role == "BUYER"
  end

  def seller?
    role == "SELLER"
  end
end
