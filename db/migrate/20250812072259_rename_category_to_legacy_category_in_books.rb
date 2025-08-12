class RenameCategoryToLegacyCategoryInBooks < ActiveRecord::Migration[8.0]
  def change
    rename_column :books, :category, :legacy_category
  end
end
