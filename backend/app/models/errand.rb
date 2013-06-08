class Errand < ActiveRecord::Base

  belongs_to :user

  attr_accessible :body, :deadline, :price, :title, :user, :errand_request, :location, :latitude, :longitude

  geocoded_by :location
end
