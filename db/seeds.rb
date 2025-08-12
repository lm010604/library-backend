# # db/seeds.rb
# require "csv"

# # 🔄 Clear existing data
# ReviewLike.delete_all
# Review.delete_all
# LibraryEntry.delete_all
# Book.delete_all
# User.delete_all
# path = Rails.root.join("db/books.csv")

# # Downcase & strip all headers so we can use lowercase keys consistently
# header_downcaser = ->(h) { h.to_s.strip.downcase }

# created = 0; skipped = 0; errors = 0

# CSV.foreach(path, headers: true, header_converters: header_downcaser) do |row|
#   title  = row["name"]&.strip
#   author = row["authors"]&.strip
#   next if title.blank? || author.blank?

#   # Safe casts
#   pages = begin
#     n = row["pagesnumber"].to_s.strip
#     n.present? ? Integer(n) : nil
#   rescue ArgumentError
#     nil
#   end

#   avg_rating = row["rating"].to_s.strip
#   avg_rating = avg_rating.present? ? avg_rating.to_f : nil

#   attrs = {
#     title:       title,
#     author:      author,
#     pages:       pages,                            # ok if nil (make pages optional in model)
#     description: row["description"].to_s,
#     avg_rating:  avg_rating
#   }

#   begin
#     book = Book.find_or_initialize_by(title:, author:)
#     book.assign_attributes(attrs)
#     book.save!
#     created += 1
#   rescue ActiveRecord::RecordInvalid => e
#     skipped += 1
#     Rails.logger.warn "Skipped #{title}: #{e.record.errors.full_messages.join(', ')}"
#   rescue => e
#     errors += 1
#     Rails.logger.error "Error on #{title}: #{e.class} #{e.message}"
#   end
# end

# # 👤 Create Users
# users = [
#   User.create!(name: "Alice", email: "alice@example.com", password: "password123", password_confirmation: "password123"),
#   User.create!(name: "Bob", email: "bob@example.com", password: "password123", password_confirmation: "password123"),
#   User.create!(name: "Charlie", email: "charlie@example.com", password: "password123", password_confirmation: "password123"),
#   User.create!(name: "Dana", email: "dana@example.com", password: "password123", password_confirmation: "password123"),
#   User.create!(name: "Eli", email: "eli@example.com", password: "password123", password_confirmation: "password123")
# ]

# # 📚 Create Books
# books = [
#   Book.create!(title: "The Ruby Way", author: "Hal Fulton", pages: 400, description: "Deep dive into Ruby programming.", avg_rating: 4.5),
#   Book.create!(title: "Clean Code", author: "Robert C. Martin", pages: 464, description: "A handbook of agile software craftsmanship.", avg_rating: 4.8),
#   Book.create!(title: "Design Patterns", author: "Erich Gamma", pages: 395, description: "Elements of reusable object-oriented software.", avg_rating: 4.6),
#   Book.create!(title: "You Don't Know JS", author: "Kyle Simpson", pages: 278, description: "Understanding JavaScript deeply.", avg_rating: 4.7),
#   Book.create!(title: "The Pragmatic Programmer", author: "Andy Hunt", pages: 352, description: "Journey to mastery in software development.", avg_rating: 4.9)
# ]

# # 📥 Add Library Entries
# users.each_with_index do |user, i|
#   LibraryEntry.create!(user: user, book: books[i % books.length], status: 0, date_added: Date.today - i)
#   LibraryEntry.create!(user: user, book: books[(i + 1) % books.length], status: 1, date_added: Date.today - i - 1)
# end

# # ✍️ Write Reviews
# reviews = []
# users.each_with_index do |user, i|
#   reviews << Review.create!(user: user, book: books[i % books.length], body: "Loved this book!", rating: 5)
#   reviews << Review.create!(user: user, book: books[(i + 2) % books.length], body: "Interesting insights.", rating: 4)
# end

# # ❤️ Like Reviews Randomly
# reviews.each_with_index do |review, i|
#   liker1 = users[(i + 1) % users.length]
#   liker2 = users[(i + 2) % users.length]

#   [liker1, liker2].each do |liker|
#     next if liker == review.user  # 🚫 Skip self-likes
#     ReviewLike.create!(review: review, user: liker)
#   end
# end

# puts "✅ Seeded #{users.count} users, #{books.count} books, #{LibraryEntry.count} entries, #{reviews.count} reviews, and #{ReviewLike.count} likes."


# puts "Seed done. Created/updated: #{created}, skipped: #{skipped}, errors: #{errors}"
