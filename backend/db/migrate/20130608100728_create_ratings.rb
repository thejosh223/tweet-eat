class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :for_user_id
      t.integer :by_user_id
      t.integer :score
      t.text :body

      t.timestamps
    end
  end
end
