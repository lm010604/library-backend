class ReviewLikesController < ApplicationController
  before_action :require_login

  def create
    review = Review.find(params[:review_id])
    return redirect_back fallback_location: review.book, alert: "Not authorized" if review.user == current_user

    review.review_likes.find_or_create_by(user: current_user)
    redirect_back fallback_location: review.book
  end

  def destroy
    review = Review.find(params[:review_id])
    review.review_likes.where(user: current_user).destroy_all
    redirect_back fallback_location: review.book
  end
end
