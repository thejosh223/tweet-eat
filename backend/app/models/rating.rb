class Rating < ActiveRecord::Base
  attr_accessible :body, :by_user_id, :for_user_id, :score

  belongs_to :by_user, :class_name => 'User', :foreign_key => 'by_user_id'
  belongs_to :for_user, :class_name => 'User', :foreign_key => 'for_user_id'
end
