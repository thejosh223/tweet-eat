class Tweet < ActiveRecord::Base
  attr_accessible :body, :importance, :restaurant_id, :sentiment

  belongs_to :restaurant
end
