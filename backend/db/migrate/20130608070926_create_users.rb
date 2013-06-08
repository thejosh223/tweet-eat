class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
      t.string :password_digest
      t.decimal :credit
      t.text :location
      t.float :latitude
      t.float :longitude

      t.timestamps
    end
  end
end
