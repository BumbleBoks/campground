require "spec_helper"

describe Community::TradesController do

  describe "should not delete other user's trade" do
    before do
      user = FactoryGirl.create(:user)
      other_user = FactoryGirl.create(:user)
      @other_trade = FactoryGirl.create(:trade, trader: other_user)
    end
    
    it "should not delete the trade" do
      delete :destroy, id: @other_trade.id
      Community::Trade.find_by(id: @other_trade.id).should_not be_nil
    end
  end
  
end
