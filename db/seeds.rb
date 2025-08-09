# db/seeds.rb
require "csv"

path = Rails.root.join("db/books.csv")

# Downcase & strip all headers so we can use lowercase keys consistently
header_downcaser = ->(h) { h.to_s.strip.downcase }

created = 0; skipped = 0; errors = 0

CSV.foreach(path, headers: true, header_converters: header_downcaser) do |row|
  title  = row["name"]&.strip
  author = row["authors"]&.strip
  next if title.blank? || author.blank?

  # Safe casts
  pages = begin
    n = row["pagesnumber"].to_s.strip
    n.present? ? Integer(n) : nil
  rescue ArgumentError
    nil
  end

  avg_rating = row["rating"].to_s.strip
  avg_rating = avg_rating.present? ? avg_rating.to_f : nil

  attrs = {
    title:       title,
    author:      author,
    pages:       pages,                            # ok if nil (make pages optional in model)
    description: row["description"].to_s,
    avg_rating:  avg_rating
  }

  begin
    book = Book.find_or_initialize_by(title:, author:)
    book.assign_attributes(attrs)
    book.save!
    created += 1
  rescue ActiveRecord::RecordInvalid => e
    skipped += 1
    Rails.logger.warn "Skipped #{title}: #{e.record.errors.full_messages.join(', ')}"
  rescue => e
    errors += 1
    Rails.logger.error "Error on #{title}: #{e.class} #{e.message}"
  end
end

puts "Seed done. Created/updated: #{created}, skipped: #{skipped}, errors: #{errors}"
