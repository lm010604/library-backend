class AddIndexesToBooks < ActiveRecord::Migration[8.0]
  def change
    add_column :books, :title, :string
    add_index :books, :title
    add_column :books, :author, :string
    add_index :books, :author
  end
end
