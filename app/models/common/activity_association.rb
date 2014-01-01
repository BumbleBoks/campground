# == Schema Information
#
# Table name: common_activity_associations
#
#  id          :integer          not null, primary key
#  activity_id :integer          not null
#  trail_id    :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Common::ActivityAssociation < ActiveRecord::Base
  belongs_to :trail, class_name: "Common::Trail", foreign_key: "trail_id"
  belongs_to :activity, class_name: "Common::Activity", foreign_key: "activity_id"
  
  validates :activity_id,  presence: true
  # validates :trail_id, presence: true
  
end
