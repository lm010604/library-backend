class RenameReviewCommentsToComments < ActiveRecord::Migration[8.0]
  def change
    rename_table :review_comments, :comments
  end
end
