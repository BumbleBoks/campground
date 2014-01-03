# == Schema Information
#
# Table name: community_trades
#
#  id             :integer          not null, primary key
#  trader_id      :integer          not null
#  trade_type     :string(255)      not null
#  gear           :string(255)      not null
#  description    :text             not null
#  activity_id    :integer
#  trade_location :string(255)      not null
#  completed      :boolean          default(FALSE)
#  created_at     :datetime
#  updated_at     :datetime
#  price          :decimal(6, 2)    default(0.0)
#

class Community::Trade < ActiveRecord::Base
  belongs_to :trader, 
             class_name: "User"

  has_many :trade_associations, class_name: "Community::TradeAssociation", 
          foreign_key: "trade_id", dependent: :destroy
  has_many :users, class_name: "User", through: :trade_associations
             
  validates :gear, presence: true
  validates :description, presence: true,
                          length: { maximum: 500 }
  validates :trade_location,  presence: true
  validates :trader_id, presence: true
  validates :price, numericality: true
  validates :trade_type, presence: true
  validate  :trade_type_is_valid
  
  default_scope { order('created_at DESC') }

  # valid entries for trade_type
  def self.valid_trade_types
    ["sell", "buy"]
  end
  
  # trade_type can by buy or sell
  def trade_type_is_valid
    unless trade_type.in?(self.class.valid_trade_types)
      errors.add(:trade_type, "is not valid")
    end
  end

  # set per_page for trades pagination 
  self.per_page = 5

end

