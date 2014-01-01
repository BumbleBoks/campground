require "spec_helper"

describe "Missing Trail pages" do
  after(:all) { clear_all_databases }
  
  let (:user) { FactoryGirl.create(:user) }
  let (:admin) { FactoryGirl.create(:admin) }
  
  subject { page }
    
  describe "list missing trails" do
    before do
      @missing_trail_one = FactoryGirl.create(:missing_trail) 
      @missing_trail_two = FactoryGirl.create(:missing_trail)       
    end
    
    describe "without logging in" do
      before { visit common_missing_trails_path }
      it_should_behave_like "home page when not logged in"
    end
    
    describe "as a regular user" do
      before do
        log_in user
        visit common_missing_trails_path 
      end
      it { should have_page_title("OnTrailAgain - #{user.name}'s Nook") }
      it { should have_selector('h2', text: "My nook") } 
    end
    
    describe "as an admin" do
      before do
        log_in admin
        visit common_missing_trails_path
      end
      it { should have_page_title('OnTrailAgain - Missing Trails') }
      it { should have_selector('h2', text: 'Listing missing trails') }

      it { should have_content(@missing_trail_one.user_email) }
      it { should have_content(@missing_trail_one.info) }

      it { should have_content(@missing_trail_two.user_email) }
      it { should have_content(@missing_trail_two.info) }

      describe "clicking a missing trail" do
        before do
          click_link @missing_trail_one.info
        end
        
        it { should have_page_title('OnTrailAgain - Missing Trail') }
        it { should have_selector('h2', text: @missing_trail_one.id) }
        it { should have_content(@missing_trail_one.user_name) }
        it { should have_content(@missing_trail_one.user_email) }
        it { should have_content(@missing_trail_one.info) }
        it { should have_content("Updates") }
      end
            
    end # admin   
  end # list missing trail page
    
    
  describe "edit an existing missing trail" do
    let(:missing_trail) { FactoryGirl.create(:missing_trail) }
    let (:submit) { "Save updates" }
    let (:back) { "Back" }
    
    describe "without logging in" do
      before { visit edit_common_missing_trail_path(missing_trail) }
      it_should_behave_like "home page when not logged in"
    end
    
    describe "as a regular user" do
      before do
        log_in user
        visit edit_common_missing_trail_path(missing_trail)
      end
      it { should have_page_title("OnTrailAgain - #{user.name}'s Nook") }
      it { should have_selector('h2', text: "My nook") } 
    end
    
    describe "as an admin" do
      before do
        log_in admin
        visit edit_common_missing_trail_path(missing_trail)
      end
      it { should have_page_title('OnTrailAgain - Missing Trail') }
      it { should have_selector('h2', text: missing_trail.id) }
      it { should have_content(missing_trail.info) }

      describe "after making changes and saving the trail" do
        before do
          fill_in "Add update", with: "Great trail"
          click_button submit
        end

        it { should have_page_title('OnTrailAgain - Missing Trail') }
        it { should have_selector('h2', text: missing_trail.id) }
        it { should have_content(missing_trail.info) }
        it { should have_content("Great trail") }
      end
      
      describe "after making changes and clicking back" do
        before do
          fill_in "Add update", with: "Long trail"
          click_link back
          visit edit_common_missing_trail_path(missing_trail)
        end

        it { should have_page_title('OnTrailAgain - Missing Trail') }
        it { should have_selector('h2', text: missing_trail.id) }
        it { should have_content(missing_trail.info) }
        it { should_not have_content("Long trail") }
      end
      
    end # admin   
  end # edit missing trail page
  
  describe "delete a missing trails" do
    before do
      @missing_trail_one = FactoryGirl.create(:missing_trail) 
      @missing_trail_two = FactoryGirl.create(:missing_trail)       
    end
        
    describe "as an admin" do
      before do
        log_in admin
        visit common_missing_trails_path        
      end
    
      it "should reduce the count by 1" do
        expect { click_link("Delete", href: "/common/missing_trails/#{@missing_trail_one.id}") }.to change(Common::MissingTrail, :count).by(-1)
      end
            
    end # admin   
  end # delete missing trail page
  

end