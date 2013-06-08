class ErrandRequest < ActiveRecord::Base
  default_scope includes(:user)
  attr_accessible :deadline, :errand, :user, :finished
  belongs_to :errand
  belongs_to :user
end
