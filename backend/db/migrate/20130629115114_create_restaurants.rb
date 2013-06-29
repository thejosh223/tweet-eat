class CreateRestaurants < ActiveRecord::Migration
  def change
    create_table :restaurants do |t|
      t.string :name
      t.float :latitude
      t.float :longitude
      t.integer :happy_count
      t.integer :neutral_count
      t.integer :sad_count

      t.timestamps
    end
  end
end
