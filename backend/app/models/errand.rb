class Errand < ActiveRecord::Base
  attr_accessible :body, :deadline, :price, :title, :user, :errand_request, :location

  geocoded_by :location

  after_validation :geocode, :if => lambda { |obj| obj.location_changed? }
end
