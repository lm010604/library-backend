class RemovePagesFromBooks < ActiveRecord::Migration[8.0]
  def change
    remove_column :books, :pages, :integer
  end
end
