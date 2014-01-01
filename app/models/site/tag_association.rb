# == Schema Information
#
# Table name: site_tag_associations
#
#  id            :integer          not null, primary key
#  tag_id        :integer          not null
#  taggable_id   :integer          not null
#  taggable_type :string(255)      not null
#  created_at    :datetime
#  updated_at    :datetime
#

class Site::TagAssociation < ActiveRecord::Base
  belongs_to :tag, class_name: "Site::Tag", foreign_key: "tag_id",
    inverse_of: :tag_associations
  belongs_to :taggable, foreign_key: "taggable_id", polymorphic: true
  
  validates :tag_id,  presence: true
  validates :taggable_id,  presence: true
  validates :taggable_type,  presence: true
end
