class AddCommentAndRating < ActiveRecord::Migration
  def up
    add_column :errand_requests, :comment, :text
    add_column :errand_requests, :rating, :integer
  end
end
