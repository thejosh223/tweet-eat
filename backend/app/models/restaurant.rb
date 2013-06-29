class Restaurant < ActiveRecord::Base
  attr_accessible :happy_count, :latitude, :longitude, :name, :neutral_count, :sad_count
end
