class AddImageUrlAndCategoryToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :image_url, :string
    add_column :books, :category, :string
  end
end
