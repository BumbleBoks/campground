require "spec_helper"

describe UsersController do
  
  describe "should not delete" do
    before do
      user = FactoryGirl.create(:user)
      @other_user = FactoryGirl.create(:user)
      log_in user
    end
    
    it "other user" do
      delete :destroy, id: @other_user.id
      User.find_by(id: @other_user.id).should_not be_nil
    end
  end
  
end
