class BooksController < ApplicationController
  def index
    @query = params[:q].to_s.strip
    @page = params[:page].to_i
    per_page = 30

    if @query.present?
      scope = Book.where("title ILIKE :q OR author ILIKE :q", q: "%#{@query}%")
      @books_count = scope.count
      offset = @page * per_page
      @books = scope.order(created_at: :desc)
                     .offset(offset)
                     .limit(per_page + 1)
      @has_next = @books.size > per_page
      @books = @books.first(per_page)
      @total_pages = (@books_count.to_f / per_page).ceil
      @results_start = offset + 1
      @results_end = [ offset + @books.size, @books_count ].min
    else
      @books = Book.none
      @books_count = 0
      @has_next = false
    end

    if logged_in?
      @personalized_sections = current_user.categories.map do |category|
        {
          category: category,
          books: category.books.limit(20)
        }
      end
    end
  end

  def show
    @book = Book.find(params[:id])
    if @book.description.blank?
      description = GoogleBooksLookup.description_for(@book)
      @book.update(description: description) if description.present?
    end
    @description = @book.description
    per_page = 6
    @page = params[:page].to_i
    offset = @page * per_page
    @reviews = @book.reviews.includes(:user, :review_likes)
                     .order(created_at: :desc)
                     .offset(offset)
                     .limit(per_page + 1)
    @has_next = @reviews.size > per_page
    @reviews = @reviews.first(per_page)
    @reviews_count = @book.reviews.count
    @total_pages = (@reviews_count.to_f / per_page).ceil
    @results_start = offset + 1
    @results_end = [ offset + @reviews.size, @reviews_count ].min
    if logged_in?
      @review = current_user.reviews.find_by(book: @book) || @book.reviews.new(user: current_user)
    else
      @review = Review.new
    end
  end

  before_action :require_login, only: [ :add_to_library, :remove_from_library, :more_favorites, :favorites ]

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

  def more_favorites
    category = current_user.categories.find_by(id: params[:category_id])
    return head :not_found unless category

    offset = params[:offset].to_i
    limit = params.fetch(:limit, 20).to_i
    books = category.books.offset(offset).limit(limit)
    render partial: "book_card", collection: books, as: :book
  end

  def favorites
    @category = current_user.categories.find_by(id: params[:category_id])
    return redirect_to books_path, alert: "Category not found" unless @category

    per_page = 30
    @page = params[:page].to_i
    offset = @page * per_page
    scope = @category.books
    @books_count = scope.count
    @books = scope.offset(offset).limit(per_page + 1)
    @has_next = @books.size > per_page
    @books = @books.first(per_page)
    @total_pages = (@books_count.to_f / per_page).ceil
    @results_start = offset + 1
    @results_end = [ offset + @books.size, @books_count ].min
  end
end
