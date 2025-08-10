class AddReviewLikesCountToReviews < ActiveRecord::Migration[8.0]
  def change
    add_column :reviews, :review_likes_count, :integer, null: false, default: 0
  end
end
