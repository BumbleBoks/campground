class Community::TradesController < ApplicationController
  before_action :set_community_trade, only: [:show]
  before_action :authorize_user
  
  def index    
  end
  
  def show 
    respond_to do |format|
      format.html
      format.js
    end
  end
  
  def new  
    @trade = current_user.trades.build 
    @trade.trade_type = "sell" 
  end
  
  def create
    @trade = current_user.trades.build(community_trade_params)
    if @trade.save
      redirect_to @trade
    else
      render 'new'
    end
  end
  
  def update
    @trade = set_users_community_trade
    @trade.toggle(:completed) and @trade.save   
    TradeMailer.trade_completed_message(@trade).deliver if @trade.completed? 
    respond_to do |format|
      format.html { redirect_to @trade }
      format.js { render 'show'}
    end
  rescue
    redirect_to root_path
  end
  
  def destroy
    @trade = set_users_community_trade
    delete_trade = @trade.dup
    users_emails = @trade.users.map { |u| u.email }
    @trade.destroy 
    TradeMailer.trade_deleted_message(delete_trade, users_emails).deliver
    redirect_to new_community_trade_path
  rescue 
    redirect_to root_path
  end
  
  private
    # Use callbacks to share common setup or constraints between actions.
    def set_users_community_trade
      @trade = current_user.trades.find_by(id: params[:id])
    end

    def set_community_trade
      @trade = Community::Trade.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def community_trade_params
      params.require(:community_trade).permit(:trade_type, :gear, :description, :activity_id,
        :trade_location, :price)
    end
end
