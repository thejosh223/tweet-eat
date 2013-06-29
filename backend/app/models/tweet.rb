class Tweet < ActiveRecord::Base
  attr_accessible :body, :importance, :restaurant_id, :sentiment
end
