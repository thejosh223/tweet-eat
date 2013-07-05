class Restaurant < ActiveRecord::Base
  attr_accessible :happy_count, :latitude, :longitude, :name, :neutral_count, :sad_count

  def self.search(search)
    search_condition = "%" + search + "%"
    find(:all, :conditions => ['title LIKE ? OR description LIKE ?', search_condition, search_condition])
  end
end
