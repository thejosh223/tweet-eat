class CreateErrands < ActiveRecord::Migration
  def change
    create_table :errands do |t|
      t.references :user
      t.string :title
      t.text :body
      t.decimal :price
      t.datetime :deadline
      t.references :errand_request

      t.timestamps
    end
  end
end
