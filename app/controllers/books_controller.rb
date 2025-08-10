class BooksController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    @books = if @query.blank?
      Book.none
    else
      Book.where("title ILIKE :q OR author ILIKE :q", q: "%#{@query}%")
          .order(created_at: :desc)
          .limit(30)
    end
  end

  def show
    @book = Book.find(params[:id])
    per_page = 6
    @page = params[:page].to_i
    offset = @page * per_page
    @reviews = @book.reviews.includes(:user, :review_likes)
                     .order(created_at: :desc)
                     .offset(offset)
                     .limit(per_page + 1)
    @has_next = @reviews.size > per_page
    @reviews = @reviews.first(per_page)
    @review  = Review.new
  end

  before_action :require_login, only: [ :add_to_library, :remove_from_library ]

  def add_to_library
    book = Book.find(params[:id])
    current_user.library_entries.find_or_create_by!(book: book) do |entry|
      entry.status ||= :not_read_yet
    end
    redirect_to library_entries_path, notice: "Added to your library."
  end

  def remove_from_library
    book = Book.find(params[:id])
    current_user.library_entries.find_by(book: book)&.destroy
    redirect_back fallback_location: library_entries_path, notice: "Removed from your library."
  end
end
