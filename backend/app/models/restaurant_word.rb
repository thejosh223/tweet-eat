class RestaurantWord < ActiveRecord::Base
  attr_accessible :count, :restaurant_id, :word

  belongs_to :restaurant
end
