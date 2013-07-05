class Restaurant < ActiveRecord::Base
  attr_accessible :happy_count, :latitude, :longitude, :name, :neutral_count, :sad_count
  has_many :comments
  has_many :restaurant_words
  has_many :tweets

  def self.search(search)
      search.blank? ? [] : all(:conditions => ['name LIKE ?', "%#{search.strip}%"])
  end

end 


