require 'spec_helper'

describe "Static pages" do  
  let (:user) { FactoryGirl.create(:user) }
  let (:state) { Common::State.find_by(name: "Colorado") }
  let (:activity) { Common::Activity.find_by(name: "Cycling") }  
  
  subject { page }
    
  describe "Home page" do
    before { visit root_path }
    
    it_should_behave_like "all pages without logging in"

    it_should_behave_like "home page when not logged in"
    
    it { should have_link("Join", href: invite_user_path) }
    
    it { should have_select('state_id') }
    it { should have_select('activity_id') } 
    it { should have_select('trail_id') }
    
    # Common::State.all.each do |state|
    #   Common::Activity.all.each do |activity|
    #     it { should have_selector('optgroup', label: "#{state.name},#{activity.name}") }
    #   end
    # end
    
    describe "trails updates" do      
      describe "trails are shown in correct category" do
        before do
          @trail_one = FactoryGirl.create(:trail, name: "Trail One", state: state, activity_ids: activity.id) 
          @trail_two = FactoryGirl.create(:trail, name: "Trail Two", state: state, activity_ids: activity.id) 
          @update1 = user.updates.create!(trail_id: @trail_one.id, content: "Icy patches on trail") 
          @update2 = user.updates.create!(trail_id: @trail_two.id, content: "Flowers blooming") 
          @label_name = "#{state.name},#{activity.name}"
          visit root_path
        end
        it { should have_optgroup_with_label_and_text(@label_name, @trail_one.name) }
        it { should have_optgroup_with_label_and_text(@label_name, @trail_two.name) }
    
        it { should_not have_content(@update1.content) }
        it { should_not have_content(@update2.content) }
      end

      describe "check for updates" do
        before do
          @trail_one = FactoryGirl.create(:trail, name: "Trail One", state: state, activity_ids: activity.id) 
          @trail_two = FactoryGirl.create(:trail, name: "Trail Two", state: state, activity_ids: activity.id) 
          @update1 = user.updates.create!(trail_id: @trail_one.id, content: "Icy patches on trail") 
          @update2 = user.updates.create!(trail_id: @trail_two.id, content: "Flowers blooming") 

          visit root_path
          select state.name
          select activity.name
          click_link "Get updates"
          # select state.name
          # select activity.name
          select @trail_one.name
          click_link "Get updates"
        end
        
        # # TODO try with phantomJS
        # describe "should have heading" do
        #   it { should have_content("Updates for #{@trail_one.name}") }
        # end
        # 
        # describe "should have update for trail one" do
        #   it { should have_content(@update1.content) } 
        # end

        describe "should not have update for trail two" do
          it { should_not have_content(@update2.content) }
        end  
      end
      
      # TODO - PhantomJS
      # describe "search for trails" do
      #   before do
      #     @trail_one = FactoryGirl.create(:trail, name: "Trail One", state: state, activity_ids: activity.id) 
      #     @trail_two = FactoryGirl.create(:trail, name: "Trail Two", state: state, activity_ids: activity.id) 
      #     @trail_three = FactoryGirl.create(:trail, name: "Path Three", state: state, activity_ids: activity.id) 
      # 
      #     visit root_path
      #     fill_in 'search_trail', with: 'trail'
      #     click_link "Search"
      #   end
      #   
      #   describe "should show trail one and trail two" do
      #     it { should have_content(@trail_one.name) }
      #     it { should have_content(@trail_two.name) }
      #   end  
      # 
      #   describe "should not show trail three" do
      #     it { should_not have_content(@trail_three.name) }
      #   end  
      # end # search for trails
      
    end
    
    describe "for logged in user" do
      before do
        @trail_one = FactoryGirl.create(:trail, name: "Trail One", state: state, activity_ids: activity.id) 
        @trail_two = FactoryGirl.create(:trail, name: "Trail Two", state: state, activity_ids: activity.id) 
        @update1 = user.updates.create!(trail_id: @trail_one.id, content: "Icy patches on trail") 
        @update2 = user.updates.create!(trail_id: @trail_two.id, content: "Flowers blooming") 
        
        user.favorite_trails.create(trail_id: @trail_one.id)
        log_in user
      end
      
      it_should_behave_like "all pages for logged in user"      
      it { should have_link("", href: user_path(user.login_id)) }
      it { should have_link("Favorites", href: favorites_show_path) }
      it { should have_link("Trails", href: common_trails_path) }
      
      it { should have_page_title("OnTrailAgain - #{user.name}'s Nook") }
      it { should have_selector('h2', text: "My nook") } 
      it { should have_content(@trail_one.name) }
      it { should have_content(user.login_id) }
      it { should have_content(@update1.content) }
      it { should_not have_content(@trail_two.name) }
      it { should_not have_content(@update2.content) } 
      
      describe "check links in two columns" do
        describe "on clicking Favorites" do
          before { click_link "Favorites" }
          
          it { should have_page_title("OnTrailAgain - #{user.name}'s Favorites") }
          it { should have_selector('h2', text: "My Favorites") }           
        end
        
        describe "on clicking Trails" do
          before { click_link "Trails" }
          
          it { should have_page_title("OnTrailAgain - Trails") }
          it { should have_selector('h2', "Search Trails") }
        end
      end # check column links           
    end   # for logged in user 
    
    describe "pagination for logged in user" do
      before do
        @trail = FactoryGirl.create(:trail, name: "Trail Favorite", state: state, activity_ids: activity.id) 
        @updates = Array.new
        6.downto(0) { |i|
          @updates[i] = user.updates.create!(trail_id: @trail.id, content: "Update #{i} for Favorite Trail") 
        }        
        user.favorite_trails.create(trail_id: @trail.id)
        log_in user
      end
      
      it { should have_page_title("OnTrailAgain - #{user.name}'s Nook") }
      it { should have_selector('h2', text: "My nook") } 
      it { should have_content(@trail.name) }
      
      5.times do |i|
        it { should have_content(@updates[i].content) }
      end
      
      5.upto(6) do |i|
        it { should_not have_content(@updates[i].content) }
      end      
    end   # pagination for logged in user 
    
  end
  
  describe "About page" do
    before { visit about_path }
    
    it_should_behave_like "all pages without logging in"
    
    it { should have_page_title("About OnTrailAgain") }
    it { should have_selector('h2', text: "About") }
    
    describe "for logged in user" do
      before do
        log_in user 
        visit about_path
      end
      
      it_should_behave_like "all pages for logged in user"      
      # it { should have_link("Profile", href: user_path(user.login_id)) }
      it { should have_link("", href: user_path(user.login_id)) }
      it { should have_page_title("About OnTrailAgain") }
      it { should have_selector('h2', text: "About") } 
    end
  end
  
  describe "Contact page" do
    before { visit contact_path }
    
    it_should_behave_like "all pages without logging in"

    it { should have_page_title("Contact OnTrailAgain") }
    it { should have_selector('h2', text: "Contact Info") }

    describe "for logged in user" do
      before do
        log_in user 
        visit contact_path
      end
      
      it_should_behave_like "all pages for logged in user" 
      
      it { should have_link("", href: user_path(user.login_id)) }
      it { should have_page_title("Contact OnTrailAgain") }
      it { should have_selector('h2', text: "Contact Info") } 
    end
  end
  
end