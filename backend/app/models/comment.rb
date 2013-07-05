class Comment < ActiveRecord::Base
  attr_accessible :comment, :name, :restaurant_id

  belongs_to :restaurant
end
