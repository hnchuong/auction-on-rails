class HomeController < ApplicationController
  allow_unauthenticated_access only: :index

  def index
    dashboard_map  = {
      buyer: dashboard_buyer_index_path,
      seller: dashboard_seller_index_path
    }
    if authenticated? # current_user
      redirect_to dashboard_map[current_user.role.downcase.to_sym]
    else
      render :index
    end
  end
end
