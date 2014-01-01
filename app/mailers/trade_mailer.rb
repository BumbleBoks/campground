class TradeMailer < ActionMailer::Base
  default from: "from@example.com"
  
  def buy_interest_message(trade, user)
    @trade = trade
    @trader = trade.trader
    @user = user
    @trade_url = community_trade_path(trade, only_path: false) 
    @trade_info = trade_info(trade)
    
    subject = "Interest in #{trade.gear}"
    to_email = @trader.email
    cc_email = @user.email
    mail to: to_email, cc: cc_email, subject: subject    
  end
  
  def sell_interest_message(trade, user)
    @trade = trade
    @trader = trade.trader
    @user = user
    @trade_url = community_trade_path(trade, only_path: false) 
    @trade_info = trade_info(trade)
    
    subject = "#{trade.gear.humanize} for sale"
    to_email = @trader.email
    cc_email = @user.email
    mail to: to_email, cc: cc_email, subject: subject        
  end
  
  def trade_completed_message(trade)
    @trade = trade
    @trade_url = community_trade_path(trade, only_path: false) 
    @trade_info = trade_info(trade)
    users_emails = trade.users.map { |u| u.email }
    
    subject = "Trade for #{trade.gear.humanize} completed"
    to_email = trade.trader.email
    bcc_email = users_emails
    mail to: to_email, bcc: bcc_email, subject: subject
  end
  
  def trade_deleted_message(trade, users_emails)
    @trade = trade
    @trade_info = trade_info(trade)
    
    subject = "Trade for #{trade.gear.humanize} deleted"
    to_email = trade.trader.email
    bcc_email = users_emails
    mail to: to_email, bcc: bcc_email, subject: subject    
  end
  
  private 
  
  def trade_info(trade)
    "#{trade.trade_type.humanize} #{trade.gear} for $#{trade.price} at #{trade.trade_location} by #{trade.trader.login_id} 
    
    #{trade.description}"    
  end
  
end
