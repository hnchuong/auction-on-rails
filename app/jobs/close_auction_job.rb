class CloseAuctionJob < ApplicationJob
  queue_as :default

  def perform(auction_id)
    auction = Auction.find_by(id: auction_id)
    return unless auction&.active?

    auction.update!(status: 'CLOSED')
    ActionCable.server.broadcast("auction_#{auction.id}", { event: "closed", auction_id: auction.id })
    ActionCable.server.broadcast("seller_#{auction.seller.id}", { event: "auction_closed", auction_id: auction.id })
  end
end
