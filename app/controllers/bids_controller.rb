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
    render action: 'create'

    # respond_to do |format|
    #   if @bid.save
    #     format.html { redirect_to @bid, notice: "Bid was successfully created." }
    #     format.json { render :show, status: :created, location: @bid }
    #   else
    #     format.html { render :new, status: :unprocessable_entity }
    #     format.json { render json: @bid.errors, status: :unprocessable_entity }
    #   end
    # end
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
