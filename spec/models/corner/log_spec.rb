# == Schema Information
#
# Table name: corner_logs
#
#  id          :integer          not null, primary key
#  user_id     :integer          not null
#  title       :string(100)      not null
#  content     :text             not null
#  activity_id :integer
#  log_date    :date             not null
#  created_at  :datetime
#  updated_at  :datetime
#

require 'spec_helper'

describe Corner::Log do
  after(:all) { clear_all_databases }
  
  let(:user) { FactoryGirl.create(:user) }
  before do
    @log = user.logs.build(title: "Test log", content: "Nice long run", 
      log_date: Date.new(2013, 04, 22) )
  end
  
  subject { @log }
  
  it { should respond_to(:user_id) }
  it { should respond_to(:title) }
  it { should respond_to(:content) }
  it { should respond_to(:activity_id) }
  it { should respond_to(:log_date) }
  it { should respond_to(:tag_associations) }
  it { should respond_to(:tags) }
  
  it { should be_valid }
  
  it { should be_invalid_with_attribute_value(:user_id, nil) }
  it { should be_invalid_with_attribute_value(:title, nil) }
  it { should be_invalid_with_attribute_value(:content, nil) }
  it { should be_invalid_with_attribute_value(:title, "d"*101) }
  it { should be_invalid_with_attribute_value(:content, "e"*1001) }
  
  describe "saving without log_date should set default log_date" do
    before do
      @log.log_date = nil
      @log.save
    end
    
    its (:log_date) { should_not be_nil }
    its (:log_date) { should eq(Time.zone.today) }
  end
  
  describe "user_id attribute", broken: true do
    it "should be inaccessible" do
      expect do
        Corner::Log.new(user_id: user.id, title: "Test log", content: "Nice long rung", 
          log_date: Date.new(2013, 04, 22))
      end.to raise_error(ActiveModel::MassAssignmentSecurity::Error)      
    end
  end
  
  describe "tag associations" do
    let(:tag) { FactoryGirl.create(:tag) }
    before do
      @log.save
      @log.tag_associations.create!(tag_id: tag.id)
    end
    it { should be_valid }
    its (:tags) { should include(tag) }
    
    it "should create a site_tag_association record" do
      Site::TagAssociation.find_by(tag_id: tag.id, taggable_id: @log.id, 
        taggable_type: "Corner::Log").should_not be_nil      
    end
    
    it "should destroy tag association for the log" do
      association_ids = @log.tag_associations.map { |assoc| assoc.id }
      @log.destroy
      association_ids.each do |id|
        Site::TagAssociation.find_by(id: id).should be_nil
      end      
    end
  end
  
end
