class ReviewsController < ApplicationController
  before_action :require_login, only: [ :index, :create, :destroy ]

  def index
    @reviews = current_user.reviews
                           .includes(:book)
                           .order(created_at: :desc)
  end

  def create
    @book   = Book.find(params[:book_id])
    @review = @book.reviews.new(review_params.merge(user: current_user))
    if @review.save
      redirect_to @book, notice: "Review posted."
    else
      @reviews = @book.reviews.includes(:user).order(created_at: :desc)
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
