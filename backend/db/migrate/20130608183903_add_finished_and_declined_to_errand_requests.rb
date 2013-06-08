class AddFinishedAndDeclinedToErrandRequests < ActiveRecord::Migration
  def change
    add_column :errand_requests, :finished, :boolean
    add_column :errand_requests, :declined, :boolean
  end
end
