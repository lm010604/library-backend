class AddIndexesToForeignKeys < ActiveRecord::Migration[8.0]
  def change
    add_index :books, :category_id unless index_exists?(:books, :category_id)
    add_index :user_categories, :user_id unless index_exists?(:user_categories, :user_id)
    add_index :user_categories, :category_id unless index_exists?(:user_categories, :category_id)
    add_index :library_entries, :user_id unless index_exists?(:library_entries, :user_id)
    add_index :library_entries, :book_id unless index_exists?(:library_entries, :book_id)
    add_index :reviews, :user_id unless index_exists?(:reviews, :user_id)
    add_index :reviews, :book_id unless index_exists?(:reviews, :book_id)
    add_index :review_likes, :user_id unless index_exists?(:review_likes, :user_id)
    add_index :review_likes, :review_id unless index_exists?(:review_likes, :review_id)
  end
end
