class ActiveAuctionsChannel < ApplicationCable::Channel
  def subscribed
    # Stream from a specific channel
    stream_from "active_auctions"
    Rails.logger.info "Client subscribed to ActiveAuctionsChannel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    Rails.logger.info "Client unsubscribed from ActiveAuctionsChannel"
  end
end
