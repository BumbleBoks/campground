require "spec_helper"

describe Common::MissingTrailsController do
  after(:all) { clear_all_databases }
  
  before do
    @user = FactoryGirl.create(:user)
    @other_user = FactoryGirl.create(:user) 
  end
  
  describe "without logging in" do
    it "should not create missing trail" do
      expect { post :create, common_missing_trail: { info: "Missing trail without logging in", \
        user_name: @user.name, user_email: @user.email } }.not_to \
        change(Common::MissingTrail, :count)
    end
  end

  # describe "after logging in" do
  #   
  #   it "should not have other user's info in missing trail" do
  #     log_in @user
  #     post :create, common_missing_trail: { info: "Missing trail with other user's info", 
  #       user_name: @other_user.name, user_email: @other_user.email } 
  #     Common::MissingTrail.find_by(user_name: @other_user.name).should be_nil
  #   end
  # 
  #   it "should have logged user's info in missing trail" do
  #     log_in @user
  #     post :create, common_missing_trail: { info: "Missing trail with other user's info" } 
  #     Common::MissingTrail.find_by(user_name: @user.name, info: "Missing trail with other user's info").should_not \
  #       be_nil
  #   end
  # 
  # end

  describe "delete method - if not admin" do
    before do
      user = FactoryGirl.create(:user)
      log_in user
      @missing_trail = FactoryGirl.create(:missing_trail)
    end
    
    it "should not delete the trail" do
      delete :destroy, id: @missing_trail.id
      Common::MissingTrail.find_by(id: @missing_trail.id).should_not be_nil
    end
    
  end

end


