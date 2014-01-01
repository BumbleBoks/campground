# == Schema Information
#
# Table name: common_missing_trails
#
#  id         :integer          not null, primary key
#  user_name  :string(255)      not null
#  user_email :string(255)      not null
#  info       :string(1000)     not null
#  updates    :string(5000)
#  created_at :datetime
#  updated_at :datetime
#

require 'spec_helper'

describe Common::MissingTrail do
  let (:user) { FactoryGirl.create(:user) }
  before { @missing_trail = Common::MissingTrail.new(user_name: user.name, user_email: user.email,
      info: "Beaten Path - A 10 mile wooded trail ...") }
  subject { @missing_trail }
  
  it { should respond_to(:user_name) }
  it { should respond_to(:user_email) }
  it { should respond_to(:info) }
  it { should respond_to(:updates) }
  it { should be_valid }
  
  it { should be_invalid_with_attribute_value(:user_name, '') }
  it { should be_invalid_with_attribute_value(:user_email, '') }
  it { should be_invalid_with_attribute_value(:info, '') }
  
  
  describe "with a very long info" do
    before { @missing_trail.info = 'm'*1001 }    
    it { should_not be_valid }
  end

  describe "with a very long updates" do
    before { @missing_trail.updates = 'm'*5001 }    
    it { should_not be_valid }
  end
  
end
