require 'spec_helper'

describe "SessionPages", type: :feature do
  after(:all) { clear_all_databases } 
  
  subject { page }
  
  describe "log in", type: :feature do
    
    before { visit login_path }
    
    it { should have_page_title("OnTrailAgain Log In") }
    it { should have_selector('h2', text: "OnTrailAgain Login") }
    
    # log in link is present in profile image
    # it { should_not have_link('Log in') } 
    it { should have_link("Join", invite_user_path) }
    it { should have_button('Forgot password?') }
    
    describe "with incorrect information" do
      before { click_button "Log in" }
      
      it { should have_content("Login ID/password combination not found") }
      it { should have_selector('h2', text: "OnTrailAgain Login") }
    end
    
    # TODO - needs config.use_transactional_fixtures = false
    # describe "on clicking Forgot password", js: true do
    #   
    #   it "should send password_reset_email" do
    #     user = FactoryGirl.create(:user)
    #     visit login_path
    #     fill_in "Login ID", with: user.login_id
    # 
    #     click_button "Forgot password?"
    #     password_change_email = ActionMailer::Base.deliveries.last 
    # 
    #     html_email_message = "Reset password"
    #     text_email_message = "Reset password by visiting"
    # 
    #     expect(password_change_email.to).to eq([user.email])
    #     expect(password_change_email.subject).to eq("Your Campground Account")
    #     expect(password_change_email.encoded).to include(html_email_message)
    #     expect(password_change_email.encoded).to include(text_email_message)    
    #   end
    
    describe "with correct information" do
      let (:user) { FactoryGirl.create(:user) }
      before do
        log_in user 
      end 
      
      it { should have_page_title("OnTrailAgain - #{user.name}'s Nook") }
      it { should have_link('Log out', href: logout_path) }
      it { should have_link("", href: user_path(user.login_id)) }
      it { should_not have_link('Join') }
      it { should_not have_link('Log in') }
      
      describe "join page should redirect to home page" do
        before { visit invite_user_path }

        it { should have_page_title("OnTrailAgain - #{user.name}'s Nook") }
        it { should have_selector('h2', text: "My nook") }       
      end      

      describe "login page should redirect to home page" do
        before { visit login_path }

        it { should have_page_title("OnTrailAgain - #{user.name}'s Nook") }
        it { should have_selector('h2', text: "My nook") }       
      end      
      
      describe "and then log out" do
        before { click_link 'Log out' }
        
        it { should have_page_title("OnTrailAgain") }
        it { should have_link('Log in', href: login_path) }
        it { should have_link('Join', href: invite_user_path) }
        it { should_not have_link('Log out') }
        it { should_not have_link('Profile') }
        
      end # log out
    end # with correct information
  end # login
end
