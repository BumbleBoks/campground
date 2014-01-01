require "spec_helper"

describe UserMailer do  
  after(:all) { clear_all_databases } 

  describe "invite email" do
    let(:email) { "invite@example.com" }      
    before do
      @request = Site::UserRequest.new
      @request.email = email
      @request.token = 'abcdefgh'
      @request.request_type ='newuser'
      @request.save
    end
    
    it "adds email to deliveries array" do
      expect do
        UserMailer.invite_message(@request).deliver      
      end.to change(ActionMailer::Base.deliveries, :count).by(1)      
    end
    
    describe "shows correct address and subject" do
      before do
        @actual_email = UserMailer.invite_message(@request).deliver      
        @html_email_message = "<p>You're invited to join OnTrailAgain.<\/p>"
        @text_email_message = "Join OnTrailAgain by visiting"
      end
    
      subject {@actual_email}
      its (:to) { should eq ([email]) }
      its (:subject) { should eq("OnTrailAgain Invitation") }
      its (:encoded) { should include(@html_email_message) }
      its (:encoded) { should include(@text_email_message) }                          
    end
  end

  describe "welcome email to new user" do  
    let(:user) { FactoryGirl.create(:user) }
    
    it "adds email to deliveries array" do
      expect do
        UserMailer.welcome_message(user).deliver      
      end.to change(ActionMailer::Base.deliveries, :count).by(1)      
    end
    
    describe "shows correct address and subject" do
      before do
        @actual_email = UserMailer.welcome_message(user).deliver      
        @html_email_message = "<p>Thank you for joining OnTrailAgain, #{user.name}.<\/p>"
        @text_email_message = "Thank you for joining OnTrailAgain, #{user.name}."
      end
    
      subject {@actual_email}
      its (:to) { should eq ([user.email]) }
      its (:subject) { should eq("Welcome to OnTrailAgain") }
      its (:encoded) { should include(@html_email_message) }
      its (:encoded) { should include(@text_email_message) }                          
    end
  end

  describe "password reset email to user" do  
    let(:user) { FactoryGirl.create(:user) }
    
    before do
      @request = Site::UserRequest.new
      @request.email = user.email
      @request.token = 'abcdefgh'
      @request.request_type ='password'
      @request.save
    end
    
    it "adds email to deliveries array" do
      expect do
        UserMailer.reset_password_message(user, @request).deliver      
      end.to change(ActionMailer::Base.deliveries, :count).by(1)      
    end
    
    describe "shows correct address and subject" do
      before do
        @actual_email = UserMailer.reset_password_message(user, @request).deliver 
        @html_email_message = "Reset password"
        @text_email_message = "Reset password by visiting"
      end
    
      subject {@actual_email}
      its (:to) { should eq ([user.email]) }
      its (:subject) { should eq("Your OnTrailAgain Account") }
      its (:encoded) { should include(@html_email_message) }
      its (:encoded) { should include(@text_email_message) }                          
    end
  end

  describe "add a trail email" do
    let(:user) { FactoryGirl.create(:user) }
    
    before do
      # log_in user
      trail_info = "Beaten Path - 10 mile long."
      @missing_trail = Common::MissingTrail.create(user_name: user.name, user_email: user.email, 
        info: trail_info)
    end
    
    it "adds email to deliveries array" do
      expect do
        UserMailer.add_trail_message(@missing_trail).deliver      
      end.to change(ActionMailer::Base.deliveries, :count).by(1)      
    end
    
    describe "shows correct addresses and subject" do
      before do
        @actual_email = UserMailer.add_trail_message(@missing_trail).deliver       
        @html_email_message = "<p>We received info on a missing trail from you<\/p>"
        @text_email_message = "We received info on a missing trail from you"
      end
    
      subject {@actual_email}
      its (:to) { should eq ([user.email]) }
      its (:bcc) { should eq ([ENV['MAIL_USERNAME']]) }
      its (:subject) { should eq("Add a new trail") }
      its (:encoded) { should include(user.name) }
      its (:encoded) { should include(@missing_trail.info) }
      its (:encoded) { should include(@html_email_message) }
      its (:encoded) { should include(@text_email_message) }                          
    end
  end

end
