class ReviewsController < ApplicationController
  include ReactProps
  before_action :require_login, only: [ :index, :create, :update, :destroy ]

  def index
    @reviews = current_user.reviews
                           .includes(:book, :review_likes, :comments)
                           .order(created_at: :desc)

    @reviews_props = {
      userName: current_user.name,
      reviews: @reviews.map { |review| review_card_props(review, current_user: current_user) },
      paths: {
        backToBooks: books_path,
        libraryEntries: library_entries_path
      },
      csrfToken: react_csrf_token
    }
  end

  def show
    @review = Review.includes(:book, :user, :review_likes, comments: [ :user, { replies: :user } ]).find(params[:id])
    @comments = @review.comments.where(parent_id: nil).includes(:user, replies: :user).order(created_at: :asc)

    @review_show_props = {
      review: review_card_props(@review, current_user: current_user, show_book: false, show_comments_link: false),
      comments: @comments.map { |comment| comment_props(comment, current_user: current_user) },
      commentsCountLabel: pluralize(@review.comments.count, "Comment"),
      loggedIn: logged_in?,
      commentForm: {
        action: review_comments_path(@review),
        parentId: nil,
        placeholder: ""
      },
      csrfToken: react_csrf_token,
      signInPath: new_session_path
    }
  end

  def create
    @book = Book.find(params[:book_id])
    @review = current_user.reviews.new(book: @book)
    @review.assign_attributes(review_params)

    if @review.save
      redirect_to @book, notice: "Review posted."
    else
      prepare_book_show_props(@book, reviews: @book.reviews.includes(:user, :review_likes, :comments).order(created_at: :desc))
      render "books/show", status: :unprocessable_entity
    end
  end

  def update
    @book = Book.find(params[:book_id])
    @review = @book.reviews.find(params[:id])

    unless @review.user == current_user
      redirect_to @book, alert: "Not authorized."
      return
    end

    if @review.update(review_params)
      redirect_to @book, notice: "Review updated."
    else
      prepare_book_show_props(@book, reviews: @book.reviews.includes(:user, :review_likes, :comments).order(created_at: :desc))
      render "books/show", status: :unprocessable_entity
    end
  end
  def destroy
    @book   = Book.find(params[:book_id])
    @review = @book.reviews.find(params[:id])
    if @review.user == current_user
      @review.destroy
      redirect_back fallback_location: my_reviews_path, notice: "Review deleted."
    else
      redirect_to @book, alert: "Not authorized."
    end
  end

  private
  def review_params
    params.require(:review).permit(:rating, :body)
  end

  def prepare_book_show_props(book, reviews:)
    per_page = 6
    page = params[:page].to_i
    offset = page * per_page
    paginated_reviews = reviews.offset(offset).limit(per_page + 1)
    has_next = paginated_reviews.size > per_page
    paginated_reviews = paginated_reviews.first(per_page)
    reviews_count = reviews.count
    total_pages = (reviews_count.to_f / per_page).ceil
    results_start = offset + 1
    results_end = [ offset + paginated_reviews.size, reviews_count ].min
    library_book_ids = current_user.library_entries.pluck(:book_id).to_set

    @reviews = paginated_reviews
    @book = book
    @page = page
    @total_pages = total_pages
    @has_next = has_next
    @reviews_count = reviews_count
    @results_start = results_start
    @results_end = results_end
    @book_show_props = build_book_show_props(
      book: book,
      reviews: paginated_reviews,
      review_form: @review,
      page: page,
      total_pages: total_pages,
      has_next: has_next,
      results_start: results_start,
      results_end: results_end,
      reviews_count: reviews_count,
      library_book_ids: library_book_ids
    )
  end
end
