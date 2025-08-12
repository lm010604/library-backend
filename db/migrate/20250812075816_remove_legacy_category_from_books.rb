class RemoveLegacyCategoryFromBooks < ActiveRecord::Migration[8.0]
  def change
    remove_column :books, :legacy_category, :string
  end
end
