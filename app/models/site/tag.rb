# == Schema Information
#
# Table name: site_tags
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Site::Tag < ActiveRecord::Base
  
  has_many :tag_associations, class_name: "Site::TagAssociation", foreign_key: "tag_id",
      inverse_of: :tag, dependent: :destroy
  has_many :taggables, through: :tag_associations
  
  has_many :tagged_logs, through: :tag_associations, source: :taggable,
      source_type: "Corner::Log"
  
  validates :name, presence: true,                
            format: { with: /\A[a-zA-Z ]+\z/ },
            length: { maximum: 20 },
            uniqueness: { case_sensitive: false }
  
  before_save { name.downcase! }
end
