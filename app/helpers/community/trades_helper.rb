module Community::TradesHelper
  def current_user_a_user?(trade)
    current_user.in?(trade.users)
  end
  
  def current_user_interested?(trade)
    interested_users = trade.trade_associations.where(association_type: "interest").map { |ta| ta.user }
    current_user.in?(interested_users)    
  end
  
  def trade_types
    Community::Trade.valid_trade_types.map { |vtt| TradeType.new(vtt) }
  end
  
  class TradeType < Struct.new(:type_string)    
    def value
      type_string.humanize
    end

    def id
      type_string
    end
  end  
end