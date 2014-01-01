# == Schema Information
#
# Table name: corner_favorite_users
#
#  id         :integer          not null, primary key
#  fan_id     :integer          not null
#  star_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Corner::FavoriteUser do
  let(:first_user) { FactoryGirl.create(:user) }
  let(:second_user) { FactoryGirl.create(:user) }
  before { @favorite_user = Corner::FavoriteUser.create(fan_id: first_user.id, star_id: second_user.id) }
  subject { @favorite_user }
  
  it { should be_valid }
  it { should respond_to(:fan_id) }
  it { should respond_to(:star_id) }
  it { should respond_to(:fan) }
  it { should respond_to(:star) }
  
  it { should be_invalid_with_attribute_value(:fan_id, nil) }
  it { should be_invalid_with_attribute_value(:star_id, nil) }
  
  describe "combination of star and fan" do
    it "should be unique" do
      expect do
        Corner::FavoriteUser.create(fan_id: first_user.id, star_id: second_user.id) 
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end    
  end
     
end
