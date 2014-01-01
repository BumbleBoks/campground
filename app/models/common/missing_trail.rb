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

class Common::MissingTrail < ActiveRecord::Base
  validates :user_name, presence: true
  validates :user_email, presence: true
  validates :info, presence: true,
            length: { maximum: 1000 }
  validates :updates,
            length: { maximum: 5000 }
            
  default_scope { order('created_at') }
end

