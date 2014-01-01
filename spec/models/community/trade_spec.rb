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

require 'spec_helper'

describe Community::Trade do
  after(:all) { clear_all_databases } 
  
  let (:user) { FactoryGirl.create(:user) }
  let (:activity) { FactoryGirl.create(:activity) }
  before { @trade = user.trades.build(gear: 'Headlamp', description: 'Brand new!', activity_id: activity.id,
      trade_type: 'sell', trade_location: 'Timbaktu') 
  }
  subject { @trade }
  
  it { should be_valid }
  it { should respond_to(:trade_type) }
  it { should respond_to(:gear) }
  it { should respond_to(:description) }
  it { should respond_to(:activity_id) }
  it { should respond_to(:trader_id) }
  it { should respond_to(:trader) }
  it { should respond_to(:price) }
  it { should respond_to(:trade_location) }
  it { should respond_to(:completed) }
  
  it { should_not be_completed }
  
  it { should be_invalid_with_attribute_value(:trade_type, nil) }
  it { should be_invalid_with_attribute_value(:gear, nil) }
  it { should be_invalid_with_attribute_value(:description, nil) }
  it { should be_invalid_with_attribute_value(:trader_id, nil) }
  it { should be_invalid_with_attribute_value(:trade_location, nil) }
  it { should be_invalid_with_attribute_value(:price, "abc") }
  it { should be_invalid_with_attribute_value(:trade_type, "save") }

  describe "trade associations" do
    let(:other_user) { FactoryGirl.create(:user) }    
    before do
      @trade.save
      other_user.trade_associations.create(trade_id: @trade.id, association_type: "wishlist")
    end
    
    it "should destroy trade associations for the trade" do
      trade_assoc_ids = @trade.trade_associations.map { |ta| ta.id }
      @trade.destroy
      
      trade_assoc_ids.each do |id|
        Community::TradeAssociation.find_by(id: id).should be_nil
      end
    end    
  end
  
end


