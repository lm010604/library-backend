puts "Running book import and category migration..."

# Import books from CSV
Rake::Task["books:import"].invoke

u1 = User.create!(name: "Karen", email: "karen@example.com", password: "password123")
u1.favorite_categories.create!()
u1.library_entries.create!(book_id: 13307, status: :read, date_addded: Date.today)
u1.library_entries.create!(book_id: 9751, status: :not_read_yet, date_addded: Date.today)
sample_reviews = [
  "This book broke me in the best way possible. I couldn’t stop thinking about Lou and Will.",
  "A moving and heartbreaking love story. It made me laugh and cry in equal measure.",
  "Beautifully written but devastating. Be prepared with tissues!",
  "The characters felt so real — I got completely lost in their world.",
  "I didn’t expect to love it as much as I did. It’s bittersweet but unforgettable."
]
u1.reviews.create!(book_id: 13307, body: sample_reviews.sample, rating: 5)

puts "Seeding complete."
