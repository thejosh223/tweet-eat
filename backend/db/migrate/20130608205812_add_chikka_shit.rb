
class AddChikkaShit < ActiveRecord::Migration
  def up
    add_column :users, :verification_code, :string
    add_column :users, :trans_id, :text
  end
end
