class BiddingChannel < ApplicationCable::Channel
  def subscribed
    logger.info "Subscribed to BiddingChannel 'buyer_#{current_user.id}'"
    stream_from "buyer_#{current_user.id}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end
end
