# == Schema Information
#
# Table name: corner_favorite_users
#
#  id         :integer          not null, primary key
#  fan_id     :integer          not null
#  star_id    :integer          not null
#  created_at :datetime
#  updated_at :datetime
#

class Corner::FavoriteUser < ActiveRecord::Base
  belongs_to :star, class_name: "User", foreign_key: "star_id"
  belongs_to :fan, class_name: "User", foreign_key: "fan_id"
  
  validates :star_id, presence: true
  validates :fan_id, presence: true
end
