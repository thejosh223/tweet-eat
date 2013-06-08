class Errand < ActiveRecord::Base

  default_scope includes(:user, :errand_requests => :user)
  belongs_to :user

  attr_accessible :body, :deadline, :price, :title, :user, :errand_request, :location, :latitude, :longitude, :finished

  geocoded_by :location

  has_many :errand_requests
end
