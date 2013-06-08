class Errand < ActiveRecord::Base

  belongs_to :user

  attr_accessible :body, :deadline, :price, :title, :user, :errand_request, :location, :finished

  geocoded_by :location

  after_validation :geocode, :if => lambda { |obj| obj.location_changed? }

  has_many :errand_requests
end
