require "spec_helper"

describe TradeMailer do
  after(:all) { clear_all_databases }
  
  describe "interest email for sell trade" do
    let(:trader) { FactoryGirl.create(:user) }
    let(:trade) { FactoryGirl.create(:trade, trader: trader, trade_type: "sell") }
    let(:user) { FactoryGirl.create(:user) }
    
    it "adds email to deliveries array" do
      expect do
        TradeMailer.buy_interest_message(trade, user).deliver
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
    
    describe "shows correct address and subject" do
      before do
        @actual_email = TradeMailer.buy_interest_message(trade, user).deliver
        @html_email_message = "<p>#{user.login_id} is interested in your gear, <a href = #{community_trade_url(trade)} >#{trade.gear}</a>. #{user.login_id} can be contacted at #{user.email}.<\/p>"
        @text_email_message = "#{user.login_id} is interested in your gear, #{trade.gear}. #{user.login_id} can be contacted at #{user.email}."
      end
      subject { @actual_email }
      its(:to) { should eq ([trader.email]) }
      its(:cc) { should eq ([user.email]) } 
      its(:subject) { should eq("Interest in #{trade.gear}") }
      its(:encoded) { should include(@html_email_message) }
      its(:encoded) { should include(@text_email_message) }
    end       
  end # interest email for sell trade
  
  describe "interest email for buy trade" do
    let(:trader) { FactoryGirl.create(:user) }
    let(:trade) { FactoryGirl.create(:trade, trader: trader, trade_type: "buy") }
    let(:user) { FactoryGirl.create(:user) }
    
    it "adds email to deliveries array" do
      expect do
        TradeMailer.sell_interest_message(trade, user).deliver
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
    
    describe "shows correct address and subject" do
      before do
        @actual_email = TradeMailer.sell_interest_message(trade, user).deliver
        @html_email_message = "<p>#{user.login_id} has gear, <a href = #{community_trade_url(trade)} >#{trade.gear}</a> for sale. #{user.login_id} can be contacted at #{user.email}.<\/p>"
        @text_email_message = "#{user.login_id} has gear, #{trade.gear} for sale. #{user.login_id} can be contacted at #{user.email}."
      end
      subject { @actual_email }
      its(:to) { should eq ([trader.email]) }
      its(:cc) { should eq ([user.email]) } 
      its(:subject) { should eq("#{trade.gear.humanize} for sale") }
      its(:encoded) { should include(@html_email_message) }
      its(:encoded) { should include(@text_email_message) }
    end       
  end # interest email for buy trade

  describe "email on trade completion" do
    let(:trader) { FactoryGirl.create(:user) }
    let(:trade) { FactoryGirl.create(:trade, trader: trader, trade_type: "buy") }
    let(:user) { FactoryGirl.create(:user) }
    
    before { user.trade_associations.create(trade_id: trade.id, association_type: "wishlist") }
    
    it "adds email to deliveries array" do
      expect do
        TradeMailer.trade_completed_message(trade).deliver
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
    
    describe "shows correct address and subject" do
      before do
        @actual_email = TradeMailer.trade_completed_message(trade).deliver
        @html_email_message = "<p>Following <a href = #{community_trade_url(trade)} >trade</a> has been marked completed by #{trade.trader.login_id}.<\/p>"
        @text_email_message = "Following trade has been marked completed by #{trade.trader.login_id}. ( The trade is at #{community_trade_url(trade)})."
      end
      subject { @actual_email }
      its(:to) { should eq ([trader.email]) }
      its(:bcc) { should eq ([user.email]) } 
      its(:subject) { should eq("Trade for #{trade.gear.humanize} completed") }
      its(:encoded) { should include(@html_email_message) }
      its(:encoded) { should include(@text_email_message) }
    end       
  end # trade completion email

  describe "email on trade deletion" do
    let(:trader) { FactoryGirl.create(:user) }
    let(:trade) { FactoryGirl.create(:trade, trader: trader, trade_type: "buy") }
    let(:user) { FactoryGirl.create(:user) }
    
    before { user.trade_associations.create(trade_id: trade.id, association_type: "interest") }
    
    it "adds email to deliveries array" do
      expect do
        TradeMailer.trade_deleted_message(trade, [user.email]).deliver
      end.to change(ActionMailer::Base.deliveries, :count).by(1)
    end
    
    describe "shows correct address and subject" do
      before do
        @actual_email = TradeMailer.trade_deleted_message(trade, [user.email]).deliver
        @html_email_message = "<p>Following trade has been deleted by #{trade.trader.login_id}.<\/p>"
        @text_email_message = "Following trade has been deleted by #{trade.trader.login_id}."
      end
      subject { @actual_email }
      its(:to) { should eq ([trader.email]) }
      its(:bcc) { should eq ([user.email]) } 
      its(:subject) { should eq("Trade for #{trade.gear.humanize} deleted") }
      its(:encoded) { should include(@html_email_message) }
      its(:encoded) { should include(@text_email_message) }
    end       
  end # trade deletion email
  
end
