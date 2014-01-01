# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  login_id        :string(50)       not null
#  name            :string(50)       not null
#  email           :string(255)      not null
#  password_digest :string(255)      not null
#  admin           :boolean          default(FALSE)
#  created_at      :datetime
#  updated_at      :datetime
#

class User < ActiveRecord::Base
  has_secure_password
  
  has_many :favorite_activities, class_name: "Corner::FavoriteActivity", 
           foreign_key: "user_id", dependent: :destroy
  has_many :activities, class_name: "Common::Activity", through: :favorite_activities
  
  has_many :favorite_trails, class_name: "Corner::FavoriteTrail", 
           foreign_key: "user_id", dependent: :destroy
  has_many :trails, class_name: "Common::Trail", through: :favorite_trails
  
  has_many :updates, class_name: "Community::Update", 
           foreign_key: "author_id", dependent: :destroy
  
  has_many :logs, class_name: "Corner::Log", 
          foreign_key: "user_id", dependent: :destroy  
  
  has_many :trades, class_name: "Community::Trade", 
          foreign_key: "trader_id", dependent: :destroy  
          
  has_many :trade_associations, class_name: "Community::TradeAssociation", 
          foreign_key: "user_id", dependent: :destroy
  has_many :reverse_trades, class_name: "Community::Trade", through: :trade_associations
          
  has_many :favorite_users, class_name: "Corner::FavoriteUser", 
           foreign_key: "fan_id", dependent: :destroy
  has_many :stars, class_name: "User", through: :favorite_users

  has_many :favorite_ofusers, class_name: "Corner::FavoriteUser", 
            foreign_key: "star_id", dependent: :destroy
  has_many :fans, class_name: "User", through: :favorite_ofusers

  VALID_LOGIN_REGEX = /\A[A-Za-z\d_]+\z/
  validates :login_id, presence: true,
            length: { minimum: 1, maximum: 50 },
            uniqueness: { case_sensitive: false },
            format: { with: VALID_LOGIN_REGEX }
            # exclusion: { in: %w("new", "create", "index", "admin", "superuser", "trailmaster") }
  validates :name, presence: true,
            length: { minimum: 1, maximum: 50 }
  VALID_EMAIL_REGEX = /\A[-a-z0-9_+\.]+\@([-a-z0-9]+\.)+[a-z0-9]{2,4}\z/i
  validates :email, presence: true,
            uniqueness: { case_sensitive: false },
            format: { with: VALID_EMAIL_REGEX }
  VALID_PASSWORD_REGEX = /.*[a-zA-z]+.*\d+.*|.*\d+.*[a-zA-z]+.*/
  validates :password, presence: true,
            length: { minimum: 6 },
            confirmation: true,
            format: { with: VALID_PASSWORD_REGEX }
  validates :password_confirmation, presence: true
  validate :login_id_is_not_reserved
  
  # login_id must not be one of the reserved words
  def login_id_is_not_reserved
    if login_id.in? ["new", "create", "index", "admin", "superuser", "trailmaster"]
      errors.add(:login_id, "must be different")
    end
  end
    
  before_save do
    login_id.downcase! 
    email.downcase!
  end
  
  # virtual attributes  
  def current_password=(password)
    self.current_password=password if password.present?
  end
  
  
  # class methods
  def self.partial_params
    [["current_password", "password", "password_confirmation"], ["login_id", "name"]]    
  end
  
  def self.password_partial_params?(user_params)
    user_params.keys.eql?(partial_params[0])
  end
  
  # instance methods
  def set_favorite_attributes(new_attribute_ids, attributes, collection)    
    user_attributes = new_attribute_ids.map { |id| collection.find_by(id: id) }    
    self.update_attribute(attributes, user_attributes)     
  end
  
  def update_partial_attributes(user_params)  
    unless self.class.partial_params.include?(user_params.keys.sort)
      self.errors.add("parmeters", "cannot be updated!")
    end
    
    if self.class.password_partial_params?(user_params)
      if self.authenticate(user_params["current_password"]) 
        user_params.delete(:current_password)
      else
        self.errors.add("current_password", "is not correct. User authentication failed")
      end
    end

    unless self.errors.any?
      self.set_partial_attributes(user_params)
    end

    !self.errors.any?
  end


  def set_partial_attributes(user_params)
    if self.validate_partial_attributes(user_params)    
      user_params.keys.each do |key|
        self.update_attribute(key, user_params[key])        
      end
    end      
  end
  
  
  def validate_partial_attributes(user_params)
    self.update_attributes(user_params)
    original_errors = self.errors.dup
    self.populate_errors_for_params(original_errors, user_params) if self.errors.any?
    !self.errors.any?
  end  
    
  
  def populate_errors_for_params(add_errors, user_params)
    self.errors.clear

      add_errors.messages.keys.each do |key|          
        if user_params.has_key?(key)
          add_errors.messages[key].each do |message|
            self.errors.add(key, message)
          end # add error message 
        end #key in user_params        
    end    
  end # populate_errors
  
end
