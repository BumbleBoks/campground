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

class Corner::Log < ActiveRecord::Base
  include Concerns::Taggable
  
  belongs_to :user, class_name: "User", foreign_key: "user_id"
  
  validates :user_id, presence: true
  validates :title, presence: true,
            length: { maximum: 100 }
  validates :content, presence: true,
            length: { maximum: 1000 }
  validates :log_date, presence: true
  
  default_scope { order('log_date DESC') }
  before_validation :set_log_date  
          
  def update_tags(tag_attributes)
    tags = []
    tag_attributes.each_key do |key| 
      tag = Site::Tag.find_or_create_by(name: tag_attributes[key]["name"]) 
      if tag.valid? 
        tags.push(tag)
      end
    end
    self.update_attribute(:tags, tags)
  end
               
  protected        
  def set_log_date
    if log_date.nil?
      self.log_date = Time.zone.today
    end    
  end        
end
