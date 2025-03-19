class Dashboard::SellerController < ApplicationController
  def index
    redirect_to root_path unless current_user.seller?

    @auctions = current_user.auctions
  end
end
