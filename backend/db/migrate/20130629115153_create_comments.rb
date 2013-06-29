class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :restaurant_id
      t.string :name
      t.float :comment

      t.timestamps
    end
  end
end
