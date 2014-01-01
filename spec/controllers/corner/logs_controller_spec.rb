require "spec_helper"

describe Corner::LogsController do
  
  describe "should not delete other user's log" do
    before do
      user = FactoryGirl.create(:user)
      log_in user
      other_user = FactoryGirl.create(:user) 
      @other_log = FactoryGirl.create(:log, user: other_user)
    end
    
    it "should not delete the log" do
      delete :destroy, id: @other_log.id
      Corner::Log.find_by(id: @other_log.id).should_not be_nil
    end
    
  end
  
end