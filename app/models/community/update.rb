# == Schema Information
#
# Table name: community_updates
#
#  id         :integer          not null, primary key
#  content    :text             not null
#  author_id  :integer          not null
#  trail_id   :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Community::Update < ActiveRecord::Base
  belongs_to :author, 
             class_name: "User"
  
  belongs_to :trail, 
             class_name: "Common::Trail"
  
  validates :content, presence: true,
            length: { maximum: 500 }
  validates :author_id, presence: true
  validates :trail_id, presence: true
  
  default_scope { order('created_at DESC') }
  
  # set per_page for updates pagination 
  self.per_page = 5
  
end
