# == Schema Information
#
# Table name: community_trade_associations
#
#  id               :integer          not null, primary key
#  trade_id         :integer          not null
#  user_id          :integer          not null
#  association_type :string(255)      not null
#  created_at       :datetime
#  updated_at       :datetime
#

class Community::TradeAssociation < ActiveRecord::Base
  belongs_to :trade, class_name: "Community::Trade", foreign_key: "trade_id"
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  
  validates :trade_id, presence: true
  validates :user_id, presence: true
  validates :association_type, presence: true
  validate  :association_type_is_valid
  validate  :user_is_not_trader
  
  def self.valid_association_types
    ["interest", "wishlist"]
  end
  
  def association_type_is_valid
    unless association_type.in?(self.class.valid_association_types)
      errors.add(:association_type, "is not valid")
    end
  end
  
  def user_is_not_trader
    if trade_id && user_id == Community::Trade.find_by(id: trade_id).trader_id
      errors.add(:user, "opened the trade") 
    end
  end
  
end
