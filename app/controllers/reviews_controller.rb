class ReviewsController < ApplicationController
  before_action :require_login, only: [ :index, :create, :update, :destroy ]

  def index
    @reviews = current_user.reviews
                           .includes(:book, :review_likes)
                           .order(created_at: :desc)
  end

  def create
    @book = Book.find(params[:book_id])
    @review = current_user.reviews.new(book: @book)
    @review.assign_attributes(review_params)

    if @review.save
      redirect_to @book, notice: "Review posted."
    else
      @reviews = @book.reviews.includes(:user, :review_likes).order(created_at: :desc)
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
      @reviews = @book.reviews.includes(:user, :review_likes).order(created_at: :desc)
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
end
