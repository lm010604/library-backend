namespace :books do
  desc "Import books from CSV"
  task import: :environment do
    require "csv"
    path = Rails.root.join("db", "books.csv")

    puts "Importing books from #{path}..."

    CSV.foreach(path, headers: true) do |row|
      next if Book.exists?(title: row["title"], author: row["author"])
      category = Category.find_or_create_by(name: row["category"].strip)
      book = Book.new(
        title:      row["title"],
        author:     row["author"],
        image_url:  row["image_url"],
        category_id:   category.id
      )

      unless book.save
        puts "Failed to import: #{row['title']} — #{book.errors.full_messages.join(', ')}"
      end
    end

    puts "Import complete!"
  end
end
