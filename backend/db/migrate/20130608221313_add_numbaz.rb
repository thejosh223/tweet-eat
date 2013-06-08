class AddNumbaz < ActiveRecord::Migration
  def up
    add_column :users, :phone_number, :string
  end
end
