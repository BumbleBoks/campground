require "spec_helper"

describe "Trail pages" do
  
  after(:all) { clear_all_databases }
  
  let (:user) { FactoryGirl.create(:user) }
  let (:admin) { FactoryGirl.create(:admin) }
  
  subject { page }
  
  describe "trail index page" do
    before { visit common_trails_path }
    
    it { should have_page_title("OnTrailAgain - Trails") }
    it { should have_selector('h2', text: "Search Trails") } 
    it { should have_content("Can't find a trail? Log in and tell us about the trail.") }
  end
  
  describe "creating a new trail" do
    let (:submit) { "Add a new trail" }
    
    describe "without logging in" do
      before { visit new_common_trail_path }
      it_should_behave_like "home page when not logged in"
    end    
    
    describe "as a regular user" do
      before do
        log_in user
        visit new_common_trail_path
      end
      it { should have_page_title("OnTrailAgain - #{user.name}'s Nook") }
      it { should have_selector('h2', text: "My nook") } 
    end
    
    describe "as an admin" do
      before do
        log_in admin
        visit new_common_trail_path        
      end
      it { should have_page_title('OnTrailAgain - New Trail') }
      it { should have_selector('h2', text: 'Create a trail') }

      # it_should_behave_like "all pages for logged in user" 
      describe "with insufficient information" do
        it "should not create a trail" do
          expect { click_button submit }.not_to change(Common::Trail, :count)
        end
      end

      describe "after submitting empty form" do
        before { click_button submit }

        it { should have_page_title('OnTrailAgain - New Trail') }
        it { should have_content('error') }
        it { should have_content('Name can\'t be blank') }
        it { should have_content('Length is not a number') }
        it { should have_content('State can\'t be blank') }
      end

      describe "with sufficient valid information" do
        before do
          fill_in "Name", with: "New Trail"
          fill_in "Length (miles)", with: 10.0
          fill_in "Description", with: "A great trail!"
          page.check "Hiking"
          page.select "Wisconsin"
        end

        it "should create a trail" do
          expect { click_button submit }.to change(Common::Trail, :count).by(1)
        end      

        describe "should create a new trail and show edit page" do
          before { click_button submit }
          let(:trail) { Common::Trail.find_by(name: "New Trail") }

          it { should have_page_title('OnTrailAgain - Edit Trail') }
          it { should have_selector('h2', text: 'Editing New Trail') }
          it { should have_field_with_name_and_value("Name", trail.name) }
          it { should have_field_with_name_and_value("Length (miles)", "10.00") }
          it { should have_field_with_name_and_value("Description", trail.description) }
          it { should have_select('common_trail_state_id', selected: "Wisconsin") }
          it { should have_checked_field("Hiking") }
        end
      end      
    end # admin user
  end #new trail page
  
  describe "edit an existing trail" do
    let(:trail) { FactoryGirl.create(:trail, name: "Old Trail", state_id: Common::State.find_by(name: "Oregon").id) }
    let (:submit) { "Save changes" }
    
    describe "without logging in" do
      before { visit edit_common_trail_path(trail_link(trail)) }
      it_should_behave_like "home page when not logged in"
    end
    
    describe "as a regular user" do
      before do
        log_in user
        visit edit_common_trail_path(trail_link(trail))
      end
      it { should have_page_title("OnTrailAgain - #{user.name}'s Nook") }
      it { should have_selector('h2', text: "My nook") } 
    end
    
    describe "as an admin" do
      before do
        log_in admin
        visit edit_common_trail_path(trail_link(trail))
      end
      it { should have_page_title('OnTrailAgain - Edit Trail') }
      it { should have_selector('h2', text: 'Editing Old Trail') }
      it { should have_field_with_name_and_value("Name", trail.name) }
      it { should have_select('common_trail_state_id', selected: "Oregon") }

      describe "after making changes and saving the trail" do
        before do
          fill_in "Name", with: "Another new trail"
          page.check "Cycling"
          page.check "Hiking"
          page.select "New York"
          click_button submit
        end

        it { should have_page_title('OnTrailAgain - Another new trail') }
        it { should have_selector('h2', text: 'Another new trail') }
        it { should have_content("New York") }
        it { should have_content("Hiking") }
        it { should have_content("Cycling") }

      end
    end # admin   
  end # edit trail page
  
  describe "show a trail" do
    let(:trail) { FactoryGirl.create(:trail, name: "Old Trail", length: 8.0, description: "Short trail",
      state_id: Common::State.find_by(name: "Idaho").id) }
    let (:submit) { "Add update" }
    
    before do
      trail.activity_associations.create(activity_id: Common::Activity.find_by(name: "Cross country skiing").id)
      trail.activity_associations.create(activity_id: Common::Activity.find_by(name: "Cycling").id)
      visit common_trail_path(trail_link(trail)) 
    end
    
    it { should have_page_title("OnTrailAgain - Old Trail") }
    it { should have_selector('h2', text: "Old Trail") }
    it { should have_selector('h4', text: "in Idaho") }
    it { should have_content("This trail is 8.0 miles long") }
    it { should have_content("Short trail") }
    it { should have_selector('h5', text: "Cycling") }
    it { should have_selector('h5', text: "Cross country skiing") }
    
    describe "without logging in" do
      it { should_not have_button("Add update") }
      it { should_not have_button('Add to favorites') }
      it { should_not have_button('Remove from favorites') }
    end
    
    describe "as a regular user" do
      before do
        log_in user
        visit common_trail_path(trail_link(trail))
      end
      it { should have_button("Add update") }
      it { should have_link('Add to favorites') }
      it { should_not have_button('Remove from favorites') }    
      
      describe "adding an update" do
        describe "with empty content" do
          it "should not add an update" do
            expect { click_button submit }.not_to change(Community::Update, :count)
          end
          
          # describe "should show error" do
          #   before { click_button submit }
          #   it { should have_content("error") }
          # end
        end
        
        describe "with valid content" do
          before { fill_in 'community_update_content', with: "Icy conditions on trail near the lake" }
          it "should add an update" do
            expect { click_button submit }.to change(Community::Update, :count).by(1)
          end
          
          describe "should show updates" do
            before { click_button submit }
            
            it { should have_content("Icy conditions on trail near the lake") }
          end
        end
      end #adding update
      
      describe "updates from other users" do
        before do
          @other_user = FactoryGirl.create(:user)
          @update = FactoryGirl.create(:update, author: @other_user, trail: trail)
          visit common_trail_path(trail_link(trail))          
        end
        
        it { should have_selector('h2', text: "Old Trail") }
        it { should have_content(@update.content) }
        it { should have_link(@other_user.login_id, user_path(@other_user)) }
      end
      
      describe "adding trail to favorites" do
        before { click_link "Add to favorites" }

        it { should have_page_title("OnTrailAgain - Old Trail") }
        it { should have_selector('h2', text: "Old Trail") }
        it { should have_link('Remove from favorites') }
        it { should_not have_link('Add to favorites') }

        describe "and then removing trail from favorites" do
          before { click_link "Remove from favorites" }
          
          it { should have_page_title("OnTrailAgain - Old Trail") }
          it { should have_selector('h2', text: "Old Trail") }
          it { should_not have_link('Remove from favorites') }
          it { should have_link('Add to favorites') }
        end
        
      end # adding trail to favorites                
    end # as a regular user
    
    describe "with updates from a deleted user account" do
      before do
        visit root_path
        deleted_user = FactoryGirl.create(:user)
        @update = FactoryGirl.create(:update, author: deleted_user, trail: trail)
        deleted_user.destroy
        visit common_trail_path(trail_link(trail)) 
      end

      it { should have_page_title("OnTrailAgain - #{trail.name}") }
      it { should have_selector('h2', text: trail.name) }
      it { should_not have_content(@update.content) }      
    end
    
    describe "pagination" do
      before do
        @updates = Array.new
        9.downto(0) { |i|
          @updates[i] = FactoryGirl.create(:update, author: user, trail: trail, content: i.to_s*50)
        }
        visit common_trail_path(trail_link(trail))
      end
      
      5.times do |i|
        it { should have_content(@updates[i].content) }
      end
      
      5.upto(9) do |i|
        it { should_not have_content(@updates[i].content) }
      end
      
    end
    
  end # show trail page
end