class CreateLibraryEntries < ActiveRecord::Migration[8.0]
  def change
    create_table :library_entries do |t|
      t.references :user, null: false, foreign_key: true
      t.references :book, null: false, foreign_key: true
      t.integer :status
      t.date :date_added

      t.timestamps
    end
  end
end
