class MakeBidService < BaseService
  attr_reader :bidder, :auction
  def initialize(bid_params:, bidder:, auction:)
    @bid_params = bid_params
    @bidder = bidder
    @auction = auction
  end

  def call
    bid = Bid.new(@bid_params)
    bid.buyer = @bidder
    bid.auction = @auction
    if bid.save
      @auction.update(current_price: bid.amount, status: 'BIDDING')
      broadcast_bid_created(bid)
      bid
    else
      raise StandardError, bid.errors.full_messages.to_sentence
    end
  end

  private

  def broadcast_bid_created(bid)
    auction = bid.auction
    ActionCable.server.broadcast("auction_#{auction.id}", {
      highest_bid: auction.highest_bid.amount,
      bidder: bidder.name
    })
    ActionCable.server.broadcast("buyer_#{bidder.id}", { event: "bid_placed", auction_id: auction.id, amount: bid.amount })
    ActionCable.server.broadcast("seller_#{auction.seller.id}", { event: "new_bid", auction_id: auction.id, highest_bid: auction.highest_bid.amount })
  end
end
