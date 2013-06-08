class AddFinishedField < ActiveRecord::Migration
  def up
    add_column(:errands, :finished, :boolean)
  end

  def down
  end
end
