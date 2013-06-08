class ErrandRequest < ActiveRecord::Base
  attr_accessible :deadline, :errand, :user
  belongs_to :errands
end
