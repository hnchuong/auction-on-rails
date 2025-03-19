class StartAuctionService < BaseService
  attr_reader :auction
  def initialize(auction:)
    @auction = auction
  end
  def call
    auction.status = 'ACTIVE'
    auction.start_time = Time.zone.now
    if auction.save
      expires_at = auction.start_time + auction.duration.minutes
      CloseAuctionJob.set(wait_until: expires_at).perform_later(auction.id)

      ActionCable.server.broadcast("active_auctions", { event: "auction_started", auction_id: auction.id })
      return true
    end
  end
end