class AuctionsController < ApplicationController
  before_action :set_auction, only: %i[edit update destroy start ]

  def new
    @auction = current_user.auctions.build
  end

  def edit
  end

  def create
    @auction = current_user.auctions.build(auction_params.merge(status: 'INACTIVE'))

    if @auction.save
      redirect_to dashboard_seller_index_path, notice: "Auction was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @auction.update(auction_params)
      redirect_to dashboard_seller_index_path, notice: "Auction was successfully updated."
    else
      render :edit, status: :unprocessable
    end
  end

  def destroy
    @auction.destroy!

    redirect_to auctions_path, status: :see_other, notice: "Auction was successfully destroyed."
  end

  def show
    @auction = Auction.find(params[:id])
  end

  def start
    if StartAuctionService.call(auction: @auction)
      render action: 'start'
    else
      render turbo_stream: turbo_stream.replace(@auction, partial: "auctions/auction", locals: { auction: @auction })
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_auction
      @auction = current_user.auctions.find(params.expect(:id))
    end

    # Only allow a list of trusted parameters through.
    def auction_params
      params.expect(auction: [ :title, :description, :starting_price, :current_price, :start_date, :start_time_only, :duration, :status, :seller_id ])
    end
end
