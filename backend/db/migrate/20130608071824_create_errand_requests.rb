class CreateErrandRequests < ActiveRecord::Migration
  def change
    create_table :errand_requests do |t|
      t.references :errand
      t.references :user
      t.datetime :deadline

      t.timestamps
    end
  end
end
