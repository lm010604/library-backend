class CommentsController < ApplicationController
  before_action :require_login

  def create
    review = Review.find(params[:review_id])
    comment = review.comments.new(comment_params.merge(user: current_user))
    if comment.save
      redirect_back fallback_location: review.book
    else
      redirect_back fallback_location: review.book, alert: comment.errors.full_messages.to_sentence
    end
  end

  def destroy
    review = Review.find(params[:review_id])
    comment = review.comments.find(params[:id])
    if comment.user == current_user
      comment.destroy
      redirect_back fallback_location: review.book, notice: "Comment deleted."
    else
      redirect_back fallback_location: review.book, alert: "Not authorized."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:body)
  end
end
