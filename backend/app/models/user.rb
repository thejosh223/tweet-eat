class User < ActiveRecord::Base
  attr_accessible :location, :credit, :email, :latitude, :longitude, :password_digest, :avatar

  has_attached_file :avatar, :styles => { :medium => '300x300', :thumb => '100x100' }, :default_url => '/images/:style/missing.png'
 
  has_secure_password

  geocoded_by :location

  after_validation :geocode, :if => lambda { |obj| obj.location_changed? }
end
