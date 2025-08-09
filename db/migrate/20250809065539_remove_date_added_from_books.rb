class RemoveDateAddedFromBooks < ActiveRecord::Migration[8.0]
  def change
    remove_column :books, :date_added, :date
  end
end
