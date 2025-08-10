class ReviewLike < ApplicationRecord
  belongs_to :review, counter_cache: true
  belongs_to :user

  validates :user_id, uniqueness: { scope: :review_id }
  validate :author_cannot_like_own_review

  private

  def author_cannot_like_own_review
    errors.add(:user_id, "can't like your own review") if review.user_id == user_id
  end
end
