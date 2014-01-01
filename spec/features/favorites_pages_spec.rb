require "spec_helper"

describe "Favorites pages" do
  let (:user) { FactoryGirl.create(:user) }
  let (:trail_one) { create_trail }
  let (:activity_one) {FactoryGirl.create(:activity) }  
  let (:trail_two) { create_trail }
  let (:activity_two) {FactoryGirl.create(:activity) }  
  let (:star) { FactoryGirl.create(:user) }
  let (:fan) { FactoryGirl.create(:user) }
  subject { page }
  
  describe "show page" do
    before { visit favorites_show_path }

    describe "without logging in" do
      it_should_behave_like "login page"
    end
    
    describe "when logged in" do
      before do
        # user.favorite_activities.create(activity_id: activity_one.id)
        user.activities.push(activity_one)
        user.favorite_trails.create(trail_id: trail_one.id)
        user.favorite_users.create(fan_id: user.id, star_id: star.id)
        user.favorite_ofusers.create(fan_id: fan.id, star_id: user.id)
        log_in user
        visit favorites_show_path
      end
      
      it { should have_page_title("OnTrailAgain - #{user.name}'s Favorites") }
      it { should have_selector('h2', text: "My Favorites") } 
      it { should have_link('Change favorites', favorites_new_path) }
      it { should have_selector('h4', text: "Trails") }
      it { should have_link("#{trail_one.name}, #{trail_one.state.name}") } 
      it { should_not have_content("#{trail_two.name}, #{trail_two.state.name}") }
      it { should have_selector('h4', text: "Activities") }
      it { should have_content(activity_one.name)} 
      it { should_not have_content(activity_two.name) }    
      it { should have_selector('h4', text: "Stars") }
      it { should have_link(star.login_id, href: user_path(star.login_id)) }
      it { should have_selector('h4', text: "Fans") }
      it { should have_link(fan.login_id, href: user_path(fan.login_id)) }
      
    end
  end
  
  describe "new page" do
    before { visit favorites_new_path }
    
    describe "without logging in" do
      it_should_behave_like "login page"
    end
    
    describe "when logged in" do
      before do
        user.activities.push(Common::Activity.find_by(name:"Hiking"))
        log_in user
        visit favorites_new_path
      end
      
      it { should have_page_title("OnTrailAgain - #{user.name}'s Favorites") }
      it { should have_selector('h2', text: "New Favorites") } 
      it { should have_button('Save favorites') }
      
      describe "remove all favorites and save" do
        before do
          page.uncheck "Hiking"
          click_button 'Save favorites'
        end
        
        it { should have_selector('h2', text: "My Favorites") } 
        it { should have_selector('h4', text: "Trails") }
        it { should have_selector('h4', text: "Activities") }
        it { should_not have_content("Hiking") }             
      end
      
      describe "change favorites and save" do
        before do
          page.check "Cycling"
          click_button 'Save favorites'
        end
        it { should have_selector('h2', text: "My Favorites") } 
        it { should have_selector('h4', text: "Trails") }
        it { should have_selector('h4', text: "Activities") }
        it { should have_content("Hiking") }
        it { should have_content("Cycling") }
      end
      
    end # new favorites - logged in    
        
  end # new page
  
end