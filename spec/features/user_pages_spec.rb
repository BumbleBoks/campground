require 'spec_helper'

describe "UserPages" do
  after(:all) { clear_all_databases } 
  
  subject { page }
  
  describe "invite_user page" do
    before { visit invite_user_path }
    let (:submit) { "Send me an invite"}

    it { should have_page_title('Join OnTrailAgain') }
    it { should have_selector('h2', text: 'Get An Invite') }
    it { should_not have_selector('button', text: 'Join') }
    it { should_not have_link('Profile') }
    it { should_not have_link('Log out') }
    it { should_not have_link('Join', href: invite_user_path) }
    it { should have_link('Log in', href: login_path) }
    
    describe "with insufficient information" do
      it "should not generate a new user request" do
        expect { click_button submit }.not_to change(Site::UserRequest, :count)        
      end
      
      describe "after submitting empty form" do
        before { click_button submit }
        
        it { should have_page_title('Join OnTrailAgain') }
        it { should have_content("Email not sent. Try again.") }
      end
    end

    describe "with invalid information" do
      before { fill_in "Email", with: "foo" }
      it "should not generate a new user request" do
        expect { click_button submit }.not_to change(Site::UserRequest, :count)        
      end
      
      describe "after submitting empty form" do
        before { click_button submit }
        
        it { should have_page_title('Join OnTrailAgain') }
        it { should have_content("Email not sent. Try again.") }
      end
    end
    
    describe "with existing user information" do
      before do
        @user = FactoryGirl.create(:user)
        visit invite_user_path
        fill_in "Email", with: @user.email
      end

      it "should not generate a new user request" do
        expect { click_button submit }.not_to change(Site::UserRequest, :count)        
      end
      
      describe "after submitting form" do
        before { click_button submit }
        
        it { should have_page_title('OnTrailAgain Log In') }
        it { should have_content("Account with that email already exists") }
      end
    end

    describe "with valid information" do
      before { fill_in "Email", with: "examplefoo@example.com" }
      
      it "should generate a new user request" do
        expect { click_button submit }.to change(Site::UserRequest, :count).by(1)
      end

      describe "should send an invite to the user" do
        before { click_button submit }
        let(:invite_email) { ActionMailer::Base.deliveries.last }
        
        it "check email" do          
          html_email_message = "<p>You're invited to join OnTrailAgain.<\/p>"
          text_email_message = "Join OnTrailAgain by visiting"

          expect(invite_email.to).to eq(["examplefoo@example.com"])
          expect(invite_email.subject).to eq("OnTrailAgain Invitation")
          expect(invite_email.encoded).to include(html_email_message)
          expect(invite_email.encoded).to include(text_email_message)     
        end        
      end
      describe "and take the user back to home page" do
        before { click_button submit }

        it { should have_link("Join", invite_user_path) }
        it { should have_link("Log in", login_path) }
      end                  
    end #valid information        

    describe "with valid information with whitespace" do
      before { fill_in "Email", with: "examplefoo@example.com " }
      
      it "should generate a new user request" do
        expect { click_button submit }.to change(Site::UserRequest, :count).by(1)
      end

      describe "should send an invite to the user" do
        before { click_button submit }
        let(:invite_email) { ActionMailer::Base.deliveries.last }
        
        it "check email" do          
          html_email_message = "<p>You're invited to join OnTrailAgain.<\/p>"
          text_email_message = "Join OnTrailAgain by visiting"

          expect(invite_email.to).to eq(["examplefoo@example.com"])
          expect(invite_email.subject).to eq("OnTrailAgain Invitation")
          expect(invite_email.encoded).to include(html_email_message)
          expect(invite_email.encoded).to include(text_email_message)     
        end        
      end
    end #valid information with whitespace
      
  end # user invite page 
    
  describe "joining process" do
    let (:submit) { "Create account" }
    before do
      user_request = Site::UserRequest.generate_new("examplefoo@example.com", "newuser")
      user_request.save
      visit edit_site_user_request_url(user_request.token)
    end
    
    it { should have_page_title('Join OnTrailAgain') }
    it { should have_selector('h2', text: 'Join OnTrailAgain') }
    it { should_not have_selector('button', text: 'Join') }
    it { should_not have_link('Profile') }
    it { should_not have_link('Log out') }
    it { should_not have_link('Join') }
    it { should have_link('Log in', href: login_path) }
    
    describe "with not enough information" do
      it "should not create a user" do 
        expect { click_button submit }.not_to change(User, :count)
      end
      
      describe "after submitting empty form" do
        before { click_button submit }
        
        it { should have_page_title('Join OnTrailAgain') }
        it { should have_content('error') }
        it { should have_content('Login can\'t be blank') }
        it { should have_content('Login is invalid') }
        it { should have_content('Name can\'t be blank') }
        it { should have_content('Password can\'t be blank') }
        it { should have_content('Password is invalid') }
        it { should have_content('Password confirmation can\'t be blank') }
        it { should have_content('Password is too short (minimum is 6 characters)') }
      end            
    end
    
    describe "with enough information" do
      before do
        fill_in "Login ID", with: "examplefoo "
        fill_in "Name", with: "Example Foo"
        fill_in "Password", with: "1foobar"
        fill_in "Confirm password", with: "1foobar"
      end

      it "should create a new user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
      
      describe "should send an email to the new user" do
        before { click_button submit }
        let(:welcome_email) { ActionMailer::Base.deliveries.last }
        
        it "check email" do          
          html_email_message = "<p>Thank you for joining OnTrailAgain, Example Foo.<\/p>"
          text_email_message = "Thank you for joining OnTrailAgain, Example Foo."

          expect(welcome_email.to).to eq(["examplefoo@example.com"])
          expect(welcome_email.subject).to eq("Welcome to OnTrailAgain")
          expect(welcome_email.encoded).to include(html_email_message)
          expect(welcome_email.encoded).to include(text_email_message)     
        end
        
      end
      
      describe "and login to home page" do
        before { click_button submit }
        let (:user) { User.find_by(login_id: "examplefoo") }
        
        it { should have_link("Log out", logout_path) }
        it { should have_link("", user_path(user.login_id)) }
        it { should_not have_link("Join") }
        it { should_not have_link("Log in") }
      end      
    end   
  end # joining process
  
  describe "show page" do
    let (:user) { FactoryGirl.create(:user) }
    let (:other_user) { FactoryGirl.create(:user) }
    let (:trail) { create_trail }
    let(:update) { user.updates.create(trail_id: trail.id, content: "Trail closed") }

    before { visit user_path (user.login_id) }
    
    it_should_behave_like "login page"
    
    describe "after logging in" do
      before do
        user.favorite_activities.create(activity_id: Common::Activity.find_by(name: "Cycling").id)
        update.save
        log_in user
        visit user_path(user.login_id)
      end      
      it { should have_page_title("OnTrailAgain - #{user.name}") }
      it { should have_selector('h2', text: "About #{user.name}") }
      it { should have_link('Change profile', edit_user_path(user.login_id)) }
      
      it { should have_content("#{user.name}") }
      it { should have_content("#{user.email}") }
      it { should have_content("Cycling") }
      it { should have_content(update.content) }  
      it { should_not have_link("Add to favorites") }    
    end
    
    describe "visiting other user's profile" do
      before do
        log_in user
        visit user_path(other_user.login_id) 
      end
      
      it { should have_page_title("OnTrailAgain - #{other_user.name}") }
      it { should have_selector('h2', text: "About #{other_user.name}") }
      it { should_not have_link('Change Profile') }
      it { should have_link("Add to stars") }
      
      describe "adding to stars" do
        before { click_link("Add to stars") }

        it { should have_page_title("OnTrailAgain - #{other_user.name}") }
        it { should have_selector('h2', text: "About #{other_user.name}") }
        it { should have_link("Remove from stars") }        
        
        describe "removing from stars" do
          before { click_link("Remove from stars") }

          it { should have_page_title("OnTrailAgain - #{other_user.name}") }
          it { should have_selector('h2', text: "About #{other_user.name}") }
          it { should have_link("Add to stars") }        
        end        
      end
      
      describe "with updates pagination" do
        before do
          @trail = create_trail
          @updates = Array.new
          6.downto(0) { |i|
            @updates[i] = other_user.updates.create!(trail_id: @trail.id, content: "Update #{i} for Favorite Trail") 
          }
          visit user_path(other_user.login_id)        
        end
        
        it { should have_content("Updates by #{other_user.name}") }
        it { should have_content(@trail.name) }
        
        5.times do |i|
          it { should have_content(@updates[i].content) }
        end

        5.upto(6) do |i|
          it { should_not have_content(@updates[i].content) }
        end      
        
      end
      
    end # other user's profile     
  end # show page
  
  describe "edit page" do
    let (:user) { FactoryGirl.create(:user) }
    let (:other_user) { FactoryGirl.create(:user) }

    describe "without logging in" do
      before { visit edit_user_path(user.login_id) }
      it_should_behave_like "login page"
    end
    
    describe "after logging in" do
      before do
        log_in user
        visit edit_user_path(user.login_id)
      end 
      
      it { should have_page_title("OnTrailAgain - Profile") }
      it { should have_selector('h2', text: "Changing Profile") }
      it { should have_link('Change favorites', favorites_new_path) }
      it { should have_link('Delete Account')}
        
      describe "on submitting invalid values" do
        before do
          fill_in "Login ID", with: other_user.login_id
          fill_in "Name", with: ""
          # fill_in "Email", with: "examplefoo@example"
          click_button "Save Profile"
        end

        it { should have_selector('h2', text: "Changing Profile") }
        it { should have_content('error') }
        it { should have_content('Login has already been taken') }
        it { should have_content('Name can\'t be blank') }
        # it { should have_content('Email is invalid') }
      end # invalid values

      describe "on submitting more invalid values" do
        before do
          fill_in "Login ID", with: ""
          fill_in "Name", with: ""
          # fill_in "Email", with: "examplefoo@example"
          click_button "Save Profile"
        end

        it { should have_selector('h2', text: "Changing Profile") }
        it { should have_content('error') }
        it { should have_content('Login can\'t be blank') }
        it { should have_content('Name can\'t be blank') }
        # it { should have_content('Email is invalid') }
      end # invalid values
      
      describe "after submitting valid values" do
        before do
          fill_in "Login ID", with: "examplefoo"
          fill_in "Name", with: "Example Foo"
          # fill_in "Email", with: "examplefoo@example.com"
          # fill_in "Password", with: "1password"
          # fill_in "Confirm password", with: "1password"
          click_button "Save Profile"
        end

         it { should have_selector('h2', text: "About Example Foo") }
        # it { should have_content("examplefoo@example.com") }
      end # valid values

      describe "after submitting valid values with whitespce" do
        before do
          fill_in "Login ID", with: "examplefoo  "
          fill_in "Name", with: "Example Foo "
          # fill_in "Email", with: "examplefoo@example.com"
          # fill_in "Password", with: "1password"
          # fill_in "Confirm password", with: "1password"
          click_button "Save Profile"
        end

         it { should have_selector('h2', text: "About Example Foo") }
        # it { should have_content("examplefoo@example.com") }
      end # valid values
      
      describe "on clicking password change button" do
        before do
          click_link "Change password"
        end
        
        it { should have_selector('h2', text: "Changing Password") }
        it { should have_selector('label', text: "New password") }
        it { should have_selector('label', text: "Confirm new password") }
        
        it { should have_link('Change profile') }
        
        describe "changing password with incorrect authentication" do
          before do
            fill_in "Current password", with: ""
            fill_in "New password", with: "1password"
            fill_in "Confirm new password", with: "1password"
            click_button "Save password"
          end
          
          it { should have_content("Current password is not correct. User authentication failed") }
          
        end

        describe "changing password with correct authentication and invalid passwords" do
          before do
            fill_in "Current password", with: user.password
            fill_in "New password", with: ""
            fill_in "Confirm new password", with: "1password"
            click_button "Save password"
          end
          
          it { should have_content("Password confirmation doesn\'t match Password") };
          it { should have_content("Password can\'t be blank") };
          it { should have_content("Password is too short (minimum is 6 characters)") };
          it { should have_content("Password is invalid") };
          
        end

        describe "changing password with correct authentication and valid passwords" do
          before do
            fill_in "Current password", with: user.password
            fill_in "New password", with: "1password"
            fill_in "Confirm new password", with: "1password"
            click_button "Save password"
          end
          
          it { should have_content("Password successfully changed") }
          it { should have_selector('h2', text: "Changing Profile") }
          it { should have_selector('label', text: 'Login ID') }
          
        end

      end # valid values
      
    end # after logging in
         
    describe "editing other user's profile" do
      before do
        log_in user
        visit edit_user_path(other_user.login_id)
      end
      
      it { should have_page_title("OnTrailAgain - #{user.name}'s Nook") }
      it { should have_selector('h2', text: "My nook") } 
    end
    
  end
  
  describe "delete user" do
    let (:user) { FactoryGirl.create(:user) }

    before do
      log_in user
      visit edit_user_path(user.login_id)
    end 
    
    it "should delete a user" do
      expect { click_link('Delete Account') }.to change(User, :count).by(-1)
    end
    
    describe "should take to home page without logging in" do
      before do
        @id = user.id
        click_link('Delete Account') 
      end 
      
      it { should have_content("User profile for #{user.login_id} deleted") }
      it { should have_page_title('OnTrailAgain') }
      it { should have_selector('h2', text: "Welcome") }
      it "should not find the user" do
        User.find_by(id: @id).should be_nil
      end
    end
    
  end
end
