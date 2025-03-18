class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy

  normalizes :email_address, with: ->(e) { e.strip.downcase }

  validates :name, presence: true
  validates :email_address, presence: true, uniqueness: true
  validates :role, presence: true, inclusion: { in: %w[BUYER SELLER] }

  has_many :auctions
  has_many :bids

  def buyer?
    role == "BUYER"
  end

  def seller?
    role == "SELLER"
  end
end
