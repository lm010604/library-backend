class FixStatusDefaultsOnLibraryEntries < ActiveRecord::Migration[8.0]
  def up
    # Your enum is { read: 0, not_read_yet: 1 }
    # 1 is the integer we want as default in the DB.
    change_column_default :library_entries, :status, from: nil, to: 1

    # Backfill any existing NULLs first (this is why your earlier attempt failed)
    execute "UPDATE library_entries SET status = 1 WHERE status IS NULL"

    # Now it's safe to enforce NOT NULL
    change_column_null :library_entries, :status, false
  end

  def down
    change_column_null    :library_entries, :status, true
    change_column_default :library_entries, :status, from: 1, to: nil
  end
end
