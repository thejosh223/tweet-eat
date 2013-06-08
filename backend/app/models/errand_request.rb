class ErrandRequest < ActiveRecord::Base
  attr_accessible :deadline, :errand, :user
end
