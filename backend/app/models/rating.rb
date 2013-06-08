class Rating < ActiveRecord::Base
  attr_accessible :body, :by_user_id, :for_user_id, :score
end
