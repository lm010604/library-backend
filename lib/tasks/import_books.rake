# lib/tasks/books_import.rake
namespace :books do
  desc "Fast CSV import using bulk upserts. ENV[path=db/books.csv, batch=5000]"
  task import: :environment do
    require "csv"
    require "set"

    csv_path   = ENV["path"].presence || Rails.root.join("db", "books.csv").to_s
    batch_size = (ENV["batch"] || "5000").to_i
    raise "batch must be >= 1" if batch_size < 1

    puts "[books:import] CSV: #{csv_path}"
    puts "[books:import] Batch size: #{batch_size}"

    normalize = ->(s) { s.nil? ? nil : s.strip }

    # --------------------------
    # PASS 1: collect unique categories
    # --------------------------
    puts "[books:import] Scanning unique categories..."
    category_names = Set.new

    CSV.foreach(csv_path, headers: true) do |row|
      cat = normalize.call(row["category"])
      next if cat.blank?
      category_names << cat
    end

    puts "[books:import] Found #{category_names.size} unique categories."

    # --------------------------
    # BULK INSERT/UPSERT CATEGORIES
    # --------------------------
    if category_names.any?
      payload = category_names.map { |name| { name: name } }
      Category.insert_all(
        payload,
        unique_by: :index_categories_on_name,
        record_timestamps: true
      )
    end

    # Build name -> id cache
    puts "[books:import] Loading category ids..."
    category_id_by_name = Category.where(name: category_names.to_a).pluck(:name, :id).to_h

    # --------------------------
    # PASS 2: upsert books in batches
    # --------------------------
    puts "[books:import] Upserting books..."
    total   = 0
    success = 0
    batch   = []

    original_log_level = ActiveRecord::Base.logger.level
    ActiveRecord::Base.logger.level = Logger::WARN

    begin
      CSV.foreach(csv_path, headers: true) do |row|
        total += 1

        title     = normalize.call(row["title"])
        author    = normalize.call(row["author"])
        image_url = normalize.call(row["image_url"])
        cat_name  = normalize.call(row["category"])

        # Skip rows that can't satisfy unique key
        next if title.blank? || author.blank?

        category_id = category_id_by_name[cat_name]

        if category_id.nil? && cat_name.present?
          Category.insert_all([ { name: cat_name } ], unique_by: :index_categories_on_name, record_timestamps: true)
          category_id = Category.where(name: cat_name).pick(:id)
          category_id_by_name[cat_name] = category_id if category_id
        end

        batch << {
          title:       title,
          author:      author,
          image_url:   image_url,
          category_id: category_id
        }

        if batch.size >= batch_size
          success += upsert_books_batch!(batch)
          batch.clear
        end
      end

      success += upsert_books_batch!(batch) if batch.any?
    rescue => e
      puts "[books:import] ERROR: #{e.class} - #{e.message}"
      puts e.backtrace.first(12)
      raise
    ensure
      ActiveRecord::Base.logger.level = original_log_level
    end

    puts "[books:import] Done. rows_seen=#{total} upserts=#{success}"
  end
end

# ---- helpers (same file) ----

def upsert_books_batch!(rows)
  return 0 if rows.empty?

  # Deduplicate within the batch by conflict key (title, author).
  # Last occurrence wins.
  deduped = {}
  rows.each do |r|
    deduped[[ r[:title], r[:author] ]] = r
  end
  rows = deduped.values

  idx_name =
    if ActiveRecord::Base.connection.index_name_exists?(:books, "index_books_on_title_and_author")
      :index_books_on_title_and_author
    else
      idx = ActiveRecord::Base.connection.indexes(:books).find { |i|
        i.unique && (i.columns == [ "title", "author" ] || i.columns == [ "author", "title" ])
      }
      raise "Unique index on [:title, :author] is required" unless idx
      idx.name.to_sym
    end

  Book.upsert_all(
    rows,
    unique_by: idx_name,
    update_only: [ :image_url, :category_id ],
    record_timestamps: true
  )

  rows.size
end
