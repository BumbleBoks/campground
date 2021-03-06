require "spec_helper"

describe "Trade pages" do
  after(:all) { clear_all_databases }
  let(:user) { FactoryGirl.create(:user) }
  
  subject { page }
  
  describe "index page" do
    before do
      @trade_user_1 = FactoryGirl.create(:trade, trader: user)
      @trade_user_2 = FactoryGirl.create(:trade, trade_type: "buy", trader: user)
      @trades = Array.new
      10.times do |i|
        some_user = FactoryGirl.create(:user)
        @trades[i] = FactoryGirl.create(:trade, trader: some_user)
      end      
    end
    
    describe "without logging in" do
      before { visit community_trades_path }
      it_should_behave_like "login page"
    end
    
    describe "as a regular user" do
      before do
        log_in user
        visit community_trades_path
      end

      it { should have_page_title("OnTrailAgain Bazaar") }
      it { should have_selector('h2', 'Open trades') }
      it { should have_link("My trades") }
      it { should have_link("Open trade") }
      it { should_not have_link("All trades") }
      
      5.upto(9) do |i| 
        it { should have_content("Sell #{@trades[i].gear}") }
        it { should have_content("by #{@trades[i].trader.login_id}") }
      end
      
      describe "with pagination" do
        4.times do |i| 
          it { should_not have_content("Sell #{@trades[i].gear}") }
        end        
      end

      describe "should not have completed trade", pending: true do
        before do 
          @trades[7].completed = true 
          visit community_trades_path
        end
        it { should_not have_content("Sell #{@trades[7].gear}") }
      end
    
      describe "to new trade page" do
        before { click_link "Open trade" }
        
        it { should have_page_title("OnTrailAgain Bazaar - New Trade") }
        it { should have_selector('h2', 'Start a new trade') }
      end

      describe "to my trades" do
        before { click_link "My trades" }
        
        it { should have_content("Buy #{@trade_user_2.gear}") }
        it { should have_content("Sell #{@trade_user_1.gear}") }

        it { should_not have_content("Sell #{@trades[9].gear}") }
        
        it { should_not have_link("My trades") }
        it { should have_link("All trades") }
        
      end
      
      # TODO PhantomJS
      # describe "search for phrase with results" do
      #   before do
      #     @other_user = FactoryGirl.create(:user)
      #     @find_trade = FactoryGirl.create(:trade, trader: @other_user, gear: "Harness")          
      #     fill_in 'trade_search_phrase', with: "harness"
      #     click_link 'Search'
      #   end
      #   
      #   it { should have_link("All trades") }
      #   it { should have_content("Sell Harness") }
      #   it { should have_content(@other_user.login_id) }
      #   
      #   9.times do |i| 
      #     it { should_not have_content("Sell #{@trades[i].gear}") }
      #   end        
      # end # search with results
      
      # describe "search for phrase with zero results" do
      #   before do
      #     visit community_trades_path
      #     fill_in 'trade_search_phrase', with: "headlamp"
      #     click_link 'Search'
      #   end
      #   
      #   it { should have_link("All trades") }
      #   it { should have_content("No matches found.") }
      #   
      #   9.times do |i| 
      #     it { should_not have_content("Sell #{@trades[i].gear}") }
      #   end                
      # end # search with no results      
      
    end # regular user
  end # index page
  
  describe "create a new trade" do
    let (:submit) { "Add trade" }
    
    describe "without logging in" do
      before { visit new_community_trade_path }
      it_should_behave_like "login page"
    end
    
    describe "as a regular user" do
      before do
        log_in user
        visit new_community_trade_path
      end
      
      it { should have_page_title("OnTrailAgain Bazaar - New Trade") }
      it { should have_selector('h2', 'Start a new trade') }
      
      describe "with insufficient information" do
        it "should not create a new trade" do
          expect { click_button submit }.not_to change(Community::Trade, :count)
        end
      end
      
      describe "after submitting empty form" do
        before { click_button submit } 
        
        it { should have_page_title("OnTrailAgain Bazaar - New Trade") }
        it { should have_content('error') }
        it { should have_content('Gear can\'t be blank') }
        it { should have_content('Description can\'t be blank') }
        it { should have_content('Trade location can\'t be blank') }        
      end
      
      describe "with sufficient valid information" do
        before do
          fill_in "Gear", with: "Trekking Poles"
          fill_in "Description", with: "Rarely used!"
          fill_in "Location", with: "Antarctica"
          fill_in "Price", with: "50.00"
        end
        
        it "should create a trade" do
          expect { click_button submit }.to change(Community::Trade, :count).by(1)
        end
        
        describe "should create a new trade and show the new trade" do
          before { click_button submit }
          
          it { should have_page_title("OnTrailAgain Bazaar - Trade") }
          it { should have_content("Sell Trekking Poles for $50.0 at Antarctica") }
          it { should have_content("Rarely used!")}
        end
      end # valid information
      
    end # regular user
  end # new trade
  
  describe "show an existing trade" do
    let(:trade) { FactoryGirl.create(:trade, trader: user) }
    
    describe "without logging in" do
      before { visit community_trade_path(trade) }
      it_should_behave_like "login page"
    end
    
    describe "as a general user" do
      before do
        other_user = FactoryGirl.create(:user)
        log_in other_user
        visit community_trade_path(trade)
      end
      it { should have_page_title("OnTrailAgain Bazaar - Trade") }
      it { should have_selector('h2', text: trade.trade_type.humanize) }
      it { should have_content("#{trade.gear} for $0.0 at #{trade.trade_location}") }
      it { should have_content("#{trade.description}")}
      it { should have_link("Interested") }
      it { should have_link("Maybe") }
      it { should_not have_link("Close") }
      it { should_not have_link("Delete") }
    end
    
    describe "by the user" do
      before do
        log_in user
        visit community_trade_path(trade)
      end
      it { should have_page_title("OnTrailAgain Bazaar - Trade") }
      it { should have_selector('h2', text: trade.trade_type.humanize) }
      it { should have_content("#{trade.gear} for $0.0 at #{trade.trade_location}") }
      it { should have_content("#{trade.description}")}
      it { should_not have_link("Interested") }
      it { should_not have_link("Maybe") }
      it { should have_link("Close") }
      it { should have_link("Delete") }
    end
    
  end # show trade
  
  describe "close trade" do
    let(:trade) { FactoryGirl.create(:trade, trader: user) }
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    
    before do
      user1.trade_associations.create(trade_id: trade.id, association_type: "interest")
      user2.trade_associations.create(trade_id: trade.id, association_type: "wishlist")
      log_in user
      visit community_trade_path(trade)
    end
        
    describe "should mark the trade as completed" do
      before { click_link('Close') }
 
      it { should have_page_title("OnTrailAgain Bazaar - Trade") }
      it { should have_selector('h2', text: trade.trade_type.humanize) }
      it { should have_content("#{trade.gear} for $0.0 at #{trade.trade_location}") }
      it { should have_content("#{trade.description}")}
      
      it { should have_text("Trade completed!") }
      it { should_not have_link("Close") }
      it { should have_link("Reopen") }
      
      describe "and then reopen" do
        before { click_link 'Reopen'}
        
        it { should have_page_title("OnTrailAgain Bazaar - Trade") }
        it { should have_selector('h2', text: trade.trade_type.humanize) }
        it { should have_content("#{trade.gear} for $0.0 at #{trade.trade_location}") }
        it { should have_content("#{trade.description}")}

        it { should_not have_text("Trade completed!") }
        it { should have_link("Close") }
        it { should_not have_link("Reopen") }                
      end
    end
    
    describe "should send email to all interested users" do
      let (:completed_email) { ActionMailer::Base.deliveries.last }
      before { click_link 'Close' }
      
      it "check mail" do
        html_email_message = "trade</a> has been marked completed by #{user.login_id}.<\/p>"
        text_email_message = "Following trade has been marked completed by #{user.login_id}."
        
        expect(completed_email.to).to eq([user.email])
        expect(completed_email.bcc).to include(user1.email)
        expect(completed_email.bcc).to include(user2.email)
        expect(completed_email.subject).to eq("Trade for #{trade.gear.humanize} completed")
        expect(completed_email.encoded).to include(html_email_message)
        expect(completed_email.encoded).to include(text_email_message)
      end
    end # email    
    
  end # close trade
  
  describe "add as a user" do
    let(:other_user) { FactoryGirl.create(:user) }
    let(:trade) { FactoryGirl.create(:trade, trader: other_user) }
    
    before do
      log_in user
      visit community_trade_path(trade)
    end
    
    describe "show interest" do
      before { click_link "Interested" }
      
      describe "should send an email to the user" do
        let(:interest_email) { ActionMailer::Base.deliveries.last }
        
        it "check email" do          
          html_email_message = "<p>#{user.login_id} is interested in your gear"
          text_email_message = "#{user.login_id} is interested in your gear, #{trade.gear}. #{user.login_id} can be contacted at #{user.email}."

          expect(interest_email.to).to eq([other_user.email])
          expect(interest_email.cc).to eq([user.email])
          expect(interest_email.subject).to eq("Interest in #{trade.gear}")
          expect(interest_email.encoded).to include(html_email_message)
          expect(interest_email.encoded).to include(text_email_message)     
        end       
      end
      
      it { should have_page_title("OnTrailAgain Bazaar - Trade") }
      it { should have_selector('h2', text: trade.trade_type.humanize) }
      it { should have_content("#{trade.gear} for $0.0 at #{trade.trade_location}") }
      it { should have_content("#{trade.description}")}

      it { should have_text("Added as Interested") }
      it { should_not have_link("Interested") }
      it { should_not have_link("Maybe") }      
    end
    
    describe "add to wishlist" do
      before { click_link "Maybe" }
            
      it { should have_page_title("OnTrailAgain Bazaar - Trade") }
      it { should have_selector('h2', text: trade.trade_type.humanize) }
      it { should have_content("#{trade.gear} for $0.0 at #{trade.trade_location}") }
      it { should have_content("#{trade.description}")}

      it { should have_text("On wishlist") }
      it { should have_link("Interested") }
      it { should_not have_link("Maybe") }      
      
      describe "and then express interest" do
        before { click_link "Interested" }
        
        describe "should send an email to the user" do
          let(:interest_email) { ActionMailer::Base.deliveries.last }

          it "check email" do          
            html_email_message = "<p>#{user.login_id} is interested in your gear"
            text_email_message = "#{user.login_id} is interested in your gear, #{trade.gear}. #{user.login_id} can be contacted at #{user.email}."

            expect(interest_email.to).to eq([other_user.email])
            expect(interest_email.cc).to eq([user.email])
            expect(interest_email.subject).to eq("Interest in #{trade.gear}")
            expect(interest_email.encoded).to include(html_email_message)
            expect(interest_email.encoded).to include(text_email_message)     
          end       
        end
        
        it { should have_page_title("OnTrailAgain Bazaar - Trade") }
        it { should have_selector('h2', text: trade.trade_type.humanize) }
        it { should have_content("#{trade.gear} for $0.0 at #{trade.trade_location}") }
        it { should have_content("#{trade.description}")}

        it { should have_text("Added as Interested") }
        it { should_not have_link("Interested") }
        it { should_not have_link("Maybe") }      
      end      
    end
    
    
  end # add as a user
  
  
  describe "delete trade" do
    let(:trade) { FactoryGirl.create(:trade, trader: user) }
    let(:user1) { FactoryGirl.create(:user) }
    let(:user2) { FactoryGirl.create(:user) }
    
    before do
      user1.trade_associations.create(trade_id: trade.id, association_type: "interest")
      user2.trade_associations.create(trade_id: trade.id, association_type: "wishlist")
      log_in user
      visit community_trade_path(trade)      
    end
    
    it "should delete trade" do
      expect { click_link('Delete') }.to change(Community::Trade, :count).by(-1)
    end
    
    describe "should take to new trade page" do
      before do
        @trade_id = trade.id
        click_link 'Delete'
      end
      
      it { should have_page_title("OnTrailAgain Bazaar - New Trade") }
      it { should have_selector('h2', 'Start a new trade') }      
      it "should not find the trade" do
        Community::Trade.find_by(id: @trade_id).should be_nil
      end
    end
      
    describe "should send email to all interested users" do
      let (:deleted_email) { ActionMailer::Base.deliveries.last }
      before { click_link 'Delete' }
      
      it "check mail" do
        html_email_message = "<p>Following trade has been deleted by #{user.login_id}.<\/p>"
        text_email_message = "Following trade has been deleted by #{user.login_id}."
        
        expect(deleted_email.to).to eq([user.email])
        expect(deleted_email.bcc).to include(user1.email)
        expect(deleted_email.bcc).to include(user2.email)
        expect(deleted_email.subject).to eq("Trade for #{trade.gear.humanize} deleted")
        expect(deleted_email.encoded).to include(html_email_message)
        expect(deleted_email.encoded).to include(text_email_message)
      end
    end # email
        
  end # delete trade  
  
end
