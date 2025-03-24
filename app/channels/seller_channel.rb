class SellerChannel < ApplicationCable::Channel
  def subscribed
    logger.info "Subscribed to SellerChannel 'seller_#{current_user.id}'"
    stream_from "seller_#{current_user.id}"
  end
end
