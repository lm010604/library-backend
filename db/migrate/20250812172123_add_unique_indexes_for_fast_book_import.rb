# db/migrate/20250812172123_add_unique_indexes_for_fast_book_import.rb
class AddUniqueIndexesForFastBookImport < ActiveRecord::Migration[8.0]
  # Required for algorithm: :concurrently on Postgres
  disable_ddl_transaction!

  def up
    # Unique category names for safe bulk insert/upsert
    unless index_exists?(:categories, :name, unique: true, name: :index_categories_on_name)
      add_index :categories, :name,
                unique: true,
                algorithm: :concurrently,
                name: :index_categories_on_name
    end

    # Unique pair for bulk upsert de-duplication
    unless index_exists?(:books, [:title, :author], unique: true, name: :index_books_on_title_and_author)
      add_index :books, [:title, :author],
                unique: true,
                algorithm: :concurrently,
                name: :index_books_on_title_and_author
    end

    # Safety: ensure FK lookup index exists (your schema already shows it)
    unless index_exists?(:books, :category_id, name: :index_books_on_category_id)
      add_index :books, :category_id,
                algorithm: :concurrently,
                name: :index_books_on_category_id
    end
  end

  def down
    remove_index :books,      name: :index_books_on_title_and_author if index_exists?(:books,      name: :index_books_on_title_and_author)
    remove_index :categories, name: :index_categories_on_name        if index_exists?(:categories, name: :index_categories_on_name)
    # Don't remove :index_books_on_category_id; it pre-existed and your app uses it.
  end
end
