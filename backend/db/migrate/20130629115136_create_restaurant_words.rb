class CreateRestaurantWords < ActiveRecord::Migration
  def change
    create_table :restaurant_words do |t|
      t.integer :restaurant_id
      t.string :word
      t.integer :count

      t.timestamps
    end
  end
end
