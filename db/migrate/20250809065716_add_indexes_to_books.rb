class AddIndexesToBooks < ActiveRecord::Migration[8.0]
  def change
    add_index :books, :title,  if_not_exists: true
    add_index :books, :author, if_not_exists: true
  end
end
