# == Schema Information
#
# Table name: corner_favorite_activities
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  activity_id :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Corner::FavoriteActivity do
  let(:user) { FactoryGirl.create(:user) }
  let(:activity) { FactoryGirl.create(:activity) }
  before { @favorite_activity = user.favorite_activities.create(activity_id: activity.id) }
  subject { @favorite_activity }
  
  it { should be_valid }
  it { should respond_to(:user_id) }
  it { should respond_to(:activity_id) }
  it { should respond_to(:user) }
  it { should respond_to(:activity) }
  
  it { should be_invalid_with_attribute_value(:user_id, nil) }
  it { should be_invalid_with_attribute_value(:activity_id, nil) }
  
  describe "combination of user and activity" do
    it "should be unique" do
      expect do
        user.favorite_activities.create(activity_id: activity.id)
      end.to raise_error(ActiveRecord::RecordNotUnique)
    end    
  end
  
  describe "accessible attributes", broken: true do
    it "should not allow access to user_id" do
      expect do
        Corner::FavoriteActivity.new(user_id: user.id, activity_id: activity.id)
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)
    end
  end
end
