require "net/http"
require "uri"
require "json"

class GoogleBooksLookup
  BASE_URL = "https://www.googleapis.com/books/v1/volumes"

  def self.description_for(book)
    query = "#{book.title} #{book.author}"
    url = URI("#{BASE_URL}?q=#{URI.encode_www_form_component(query)}&key=#{ENV['GOOGLE_BOOKS_API_KEY']}")
    response = Net::HTTP.get(url)
    data = JSON.parse(response)

    volume = data["items"]&.first
    volume&.dig("volumeInfo", "description")
  rescue => e
    Rails.logger.error("Google Books API error: #{e.message}")
    nil
  end
end
