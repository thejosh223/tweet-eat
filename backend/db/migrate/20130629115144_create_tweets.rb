class CreateTweets < ActiveRecord::Migration
  def change
    create_table :tweets do |t|
      t.integer :restaurant_id
      t.string :body
      t.float :importance
      t.float :sentiment

      t.timestamps
    end
  end
end
