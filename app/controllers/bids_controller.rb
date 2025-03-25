class BidsController < ApplicationController
  before_action :set_auction

  # GET /bids or /bids.json
  def index
    @bids = Bid.all
  end

  # POST /bids or /bids.json
  def create
    @bid = current_user.bids.build(bid_params)
    @bid.auction = @auction

    @bid = MakeBidService.call(bid_params: bid_params, bidder: current_user, auction: @auction)
    if @bid.persisted?
      render action: 'create'
    else
      render action: 'error'
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction
      @auction = Auction.find(params[:auction_id])
    end

    # Only allow a list of trusted parameters through.
    def bid_params
      params.expect(bid: [ :amount ])
    end
end
