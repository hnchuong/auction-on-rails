class AuctionChannel < ApplicationCable::Channel
  def subscribed
    logger.info "Subscribed to AuctionChannel 'auction_#{params[:auction_id]}'"
    stream_from "auction_#{params[:auction_id]}"
  end
end
