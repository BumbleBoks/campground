require "spec_helper"

describe Community::TradesController do

  describe "should not delete " do
    before do
      user = FactoryGirl.create(:user)
      other_user = FactoryGirl.create(:user)
      @other_trade = FactoryGirl.create(:trade, trader: other_user)
      log_in user
    end
    
    it "other user's trade" do
      delete :destroy, id: @other_trade.id
      Community::Trade.find_by(id: @other_trade.id).should_not be_nil
    end
  end

  describe "trader cannot be added" do
    before do
      @user = FactoryGirl.create(:user)
      @trade = FactoryGirl.create(:trade, trader: @user)
      log_in @user
    end
    
    it "as an interested user" do
      post :interested, trade_id: @trade.id
      Community::TradeAssociation.find_by(user_id: @user.id, trade_id: @trade.id).should be_nil
    end
    
    it "as user with item on wishlist" do
      post :maybe, trade_id: @trade.id
      Community::TradeAssociation.find_by(user_id: @user.id, trade_id: @trade.id).should be_nil
    end
    
  end
  
end
