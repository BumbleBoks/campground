class Community::TradesController < ApplicationController
  before_action :set_community_trade, only: [:show]
  before_action :authorize_user
  
  def index  
    if params.has_key?(:trades)
      @trades = current_user.trades.where(completed: false).page(params[:page])
      @all_trades = false
      @heading = "My Open Trades"
    elsif params.has_key?(:q)
      search_params = params[:q].downcase
      @trades = Community::Trade.where("LOWER(gear) LIKE ? or LOWER(description) LIKE ?", 
        "%#{search_params}%", "%#{search_params}%").page(params[:page])
      @all_trades = false
      @heading = "Search Results"
    else
      @trades = Community::Trade.where(completed: false).page(params[:page])  
      @all_trades = true
      @heading = "All Open Trades"
    end

    respond_to do |format|
      format.html
      format.js
    end        
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
  
  def interested
    @trade = Community::Trade.find_by(id: params[:trade_id])
    if current_user_a_user?(@trade)
      @trade_association = @trade.trade_associations.find_by(user_id: current_user.id)
      @trade_association.association_type = "interest" and @trade_association.save
    else
      @trade.trade_associations.create(user_id: current_user.id, association_type: "interest")
    end
    
    case @trade.trade_type
    when 'buy'
      TradeMailer.sell_interest_message(@trade, @current_user).deliver

    when 'sell'
      TradeMailer.buy_interest_message(@trade, @current_user).deliver
    end
    
    redirect_to :back
  end
  
  def maybe
    @trade = Community::Trade.find_by(id: params[:trade_id])
    @trade.trade_associations.create(user_id: current_user.id, association_type: "wishlist")
    redirect_to :back    
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
