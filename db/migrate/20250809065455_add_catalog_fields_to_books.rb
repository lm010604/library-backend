class AddCatalogFieldsToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :description, :text
    add_column :books, :avg_rating, :float
  end
end
