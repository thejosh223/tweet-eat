class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.int :for_user_id
      t.int :by_user_id
      t.int :score
      t.text :body

      t.timestamps
    end
  end
end
