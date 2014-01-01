# == Schema Information
#
# Table name: site_tags
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Site::Tag do
  after(:all) { clear_all_databases }
  before { @tag = Site::Tag.new(name: "test") }
  subject { @tag }
  
  it { should respond_to(:name) }
  it { should respond_to(:tag_associations) }
  it { should respond_to(:taggables) }
  it { should be_valid }
  
  it { should be_invalid_with_attribute_value(:name, nil) }
  
  describe "with valid names" do
    valid_names = ["xyz", "abc def"]
    
    valid_names.each do |name|
      before { @tag.name = name }
      it { should be_valid }
    end   
  end
  
  describe "with duplicate name" do
    before do
      tag_with_same_name = @tag.dup
      tag_with_same_name.name.upcase!
      tag_with_same_name.save
    end
    it { should_not be_valid }
  end
  
  describe "with invalid names" do
    invalid_names = ["abc765", "$a#b?3c", "%abc", "b@ca<}", "!/1*abc"]    
    invalid_names.each do |name|
      it { should be_invalid_with_attribute_value(:name, name) }
    end
  end
  
  describe "with a long name" do
    before { @tag.name = "t"*21 }
    it { should_not be_valid }
  end

  describe "tag associations" do
    let(:user) { FactoryGirl.create(:user) }
    before do
      @log = FactoryGirl.create(:log, user: user)       
      @tag.save
      @log.tag_associations.create!(tag_id: @tag.id)
    end
    
    it "should create a site_tag_association record" do
      Site::TagAssociation.find_by(tag_id: @tag.id, taggable_id: @log.id, 
        taggable_type: "Corner::Log").should_not be_nil      
    end
    
    its (:tagged_logs) { should include(@log) }
    
    it "should destroy tag association for the user" do
      association_ids = @tag.tag_associations.map { |assoc| assoc.id }
      @tag.destroy
      association_ids.each do |id|
        Site::TagAssociation.find_by(id: id).should be_nil
      end      
    end
  end
  
end
