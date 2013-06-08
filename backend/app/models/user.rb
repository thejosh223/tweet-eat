class User < ActiveRecord::Base

  has_attached_file :avatar, :styles => { :medium => '300x300>', :thumb => '100x100' }, :default_url => '/images/:style/missing.png'
 
  has_secure_password
  attr_accessible :first_name, :last_name, :credit, :email, :latitude, :longitude, :password_digest, :avatar, :fb_id, :location, :latitude, :longitude

  geocoded_by :location
end
