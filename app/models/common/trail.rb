# == Schema Information
#
# Table name: common_trails
#
#  id          :integer          not null, primary key
#  name        :string(75)       not null
#  length      :decimal(5, 2)
#  description :text
#  state_id    :integer          not null
#  created_at  :datetime
#  updated_at  :datetime
#

class Common::Trail < ActiveRecord::Base
  
  belongs_to :state, class_name: "Common::State"
  
  has_many :activity_associations, class_name: "Common::ActivityAssociation", 
          foreign_key: "trail_id", dependent: :destroy
  has_many :activities, class_name: "Common::Activity", through: :activity_associations

  has_many :favorite_trails, class_name: "Corner::FavoriteTrail", 
           foreign_key: "trail_id", dependent: :destroy
  has_many :users, class_name: "User", through: :favorite_trails

  has_many :updates, class_name: "Community::Update", 
           foreign_key: "trail_id", dependent: :destroy
             
  VALID_NAME_REGEX = /\A[A-Za-z\d_]+( |\w)*\z/
  validates :name, presence: true,
            uniqueness: { scope: :state_id }
  validates :length,  numericality: true
  validates :state_id, presence: true
end
