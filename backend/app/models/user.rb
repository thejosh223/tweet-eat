class User < ActiveRecord::Base

  has_attached_file :avatar, :styles => { :medium => '300x300>', :thumb => '100x100' }, :default_url => '/images/:style/missing.png'
 
  has_secure_password
  attr_accessible :credit, :email, :latitude, :longitude, :password_digest, :avatar, :fb_id, :location

  geocoded_by :location

  after_validation :geocode, :if => lambda { |obj| obj.location_changed? }
end
