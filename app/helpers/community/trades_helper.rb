module Community::TradesHelper
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