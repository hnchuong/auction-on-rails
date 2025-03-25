class Dashboard::BuyerController < ApplicationController
  def index
    redirect_to root_path unless current_user.buyer?

    @auctions = Auction.active.order(
      Arel.sql("CASE auctions.status
        WHEN 'BIDDING' THEN 1
        WHEN 'ACTIVE' THEN 2
        WHEN 'INACTIVE' THEN 3
        WHEN 'CLOSED' THEN 4
        ELSE 5 END")
    )
  end
end
