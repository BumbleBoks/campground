require "active_support/concern"

module Concerns::Taggable
  extend ActiveSupport::Concern
  
  included do
    has_many :tag_associations, class_name: "Site::TagAssociation", foreign_key: "taggable_id",
      as: :taggable, dependent: :destroy
    has_many :tags, class_name: "Site::Tag", through: :tag_associations
    
    accepts_nested_attributes_for :tags
    
  end
end

