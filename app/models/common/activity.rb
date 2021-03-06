# == Schema Information
#
# Table name: common_activities
#
#  id         :integer          not null, primary key
#  name       :string(255)      not null
#  created_at :datetime
#  updated_at :datetime
#

class Common::Activity < ActiveRecord::Base
  
  has_many :activity_associations, class_name: "Common::ActivityAssociation", 
           foreign_key: "activity_id", dependent: :destroy
  has_many :trails, class_name: "Common::Trail", through: :activity_associations
  
  has_many :favorite_activities, class_name: "Corner::FavoriteActivity", 
           foreign_key: "activity_id", dependent: :destroy
  has_many :users, class_name: "User", through: :favorite_activities
  
  VALID_NAME_REGEX = /\A[A-Za-z\d_]+( |\w)*\z/
  validates :name,  presence: true,
            uniqueness: { case_sensitivity: false },
            format: { with: VALID_NAME_REGEX }
  
end
