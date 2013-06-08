class Errand < ActiveRecord::Base

  belongs_to :user

  attr_accessible :body, :deadline, :price, :title, :user, :errand_request, :location, :latitude, :longitude, :finished

  geocoded_by :location

  has_many :errand_requests
end
