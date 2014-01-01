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

require 'spec_helper'

describe Community::TradeAssociation do
  let (:trader) { FactoryGirl.create(:user) }
  let (:trade) { FactoryGirl.create(:trade, trader: trader) }
  let (:other_user) { FactoryGirl.create(:user) }
  before { @trade_association = other_user.trade_associations.create(trade_id: trade.id, association_type: "interest") }
  
  subject { @trade_association }
  
  it { should be_valid }
  it { should respond_to(:trade_id) }
  it { should respond_to(:trade) }
  it { should respond_to(:user_id) }
  it { should respond_to(:user) }
  it { should respond_to(:association_type) }

  it { should be_invalid_with_attribute_value(:user_id, nil) }
  it { should be_invalid_with_attribute_value(:trade_id, nil) }
  it { should be_invalid_with_attribute_value(:association_type, nil) }
  it { should be_invalid_with_attribute_value(:association_type, "random") }
  
  describe "combination of trade and user" do
    it "should be unique" do
      expect do
        other_user.trade_associations.create(trade_id: trade.id, association_type: "interest")
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end
  end
  
  describe "assocation between trade and trader" do
    before { @new_trade_association = trader.trade_associations.build(trade_id: trade.id, \
      association_type: "wishlist") }
    it "should be invalid" do
      @new_trade_association.should_not be_valid 
    end
  end
  
end
