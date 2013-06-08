class AddLocationToErrand < ActiveRecord::Migration
  def change
    add_column :errands, :location, :text
    add_column :errands, :latitude, :float
    add_column :errands, :longitude, :float
  end
end
