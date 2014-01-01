# == Schema Information
#
# Table name: common_trails
#
#  id          :integer          not null, primary key
#  name        :string(75)       not null
#  length      :decimal(5, 2)
#  description :text
#  state_id    :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Common::Trail do
  let (:state) { FactoryGirl.create(:state) }
  before { @trail = state.trails.build(name: "Foo Trail", length: 10.0, 
    description: "It's an ideal foo trail") }
  subject { @trail }
  
  it { should respond_to(:name) }
  it { should respond_to(:length) }
  it { should respond_to(:description) }
  it { should respond_to(:state) }
  it { should respond_to(:activity_associations) }
  it { should respond_to(:activities) }
  it { should respond_to(:updates) }
  it { should respond_to(:favorite_trails) }
  it { should respond_to(:users) }
  it { should be_valid }
  
  it { should be_invalid_with_attribute_value(:name, '') }
  it { should be_invalid_with_attribute_value(:length, 'abc') }
  it { should be_invalid_with_attribute_value(:state_id, nil) }
  
  describe "same trail name with same state" do
    before do
      dup_trail = state.trails.build(name: @trail.name, length: 5.0)
      dup_trail.save
    end
    it "should not save" do
      expect { @trail.save }.not_to change(Common::Trail, :count)
    end
  end

  describe "same trail name with different state" do
    before do
      new_state = FactoryGirl.create(:state, name: "New State")
      dup_trail = new_state.trails.build(name: @trail.name, length: 5.0)
      dup_trail.save
    end
    it "should save" do
      expect { @trail.save }.to change(Common::Trail, :count).by(1)      
    end
  end  
  
  # TODO - test for presence of activities
  
  describe "activity associations" do
    let!(:activity) { FactoryGirl.create(:activity) }
    before { @trail.activity_associations.build(activity_id: activity.id) }
    
    it "should destroy activity_associations for the trail" do
      association_ids = @trail.activity_associations.map { |assoc| assoc.id }
      @trail.destroy
      association_ids.each do |id|
        Common::ActivityAssociation.find_by(id: id).should be_nil
      end
    end
  end
  
  describe "update associations" do
    let!(:user) { FactoryGirl.create(:user) }
    before do
      @trail.save
      FactoryGirl.create(:update, content: "Lorem ipsum", author: user, trail: @trail) 
    end 
    
    it "should destroy update associations for the trail" do
      update_ids = @trail.updates.map { |update| update.id }
      @trail.destroy
      update_ids.each do |id|
        Community::Update.find_by(id: id).should be_nil
      end
    end
  end

  describe "favorite trails associations" do
    let!(:user) { FactoryGirl.create(:user) }
    before do
      @trail.save
      user.favorite_trails.create!(trail_id: @trail.id)
    end 
    
    it "should destroy favorite trails associations for the trail" do
      favorite_ids = @trail.favorite_trails.map { |favs| favs.id }
      @trail.destroy
      favorite_ids.each do |id|
        Corner::FavoriteTrail.find_by(id: id).should be_nil
      end
    end
  end


end
