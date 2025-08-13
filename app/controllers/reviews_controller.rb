class ReviewsController < ApplicationController
  before_action :require_login, only: [ :index, :create, :destroy ]

  def index
    @reviews = current_user.reviews
                           .includes(:book, :review_likes)
                           .order(created_at: :desc)
  end

  def create
    @book = Book.find(params[:book_id])
    @review = Review.find_or_initialize_by(user: current_user, book: @book)
    @review.assign_attributes(review_params)
    was_new = @review.new_record?

    if @review.save
      message = was_new ? "Review posted." : "Review updated."
      redirect_to @book, notice: message
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
      redirect_to @book, notice: "Review deleted."
    else
      redirect_to @book, alert: "Not authorized."
    end
  end

  private
  def review_params
    params.require(:review).permit(:rating, :body)
  end
end
