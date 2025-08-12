puts "Running book import and category migration..."

# Import books from CSV
Rake::Task["books:import"].invoke

puts "Seeding complete."
