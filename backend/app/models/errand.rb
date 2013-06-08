class Errand < ActiveRecord::Base
  attr_accessible :body, :deadline, :price, :title, :user, :errand_request
end
