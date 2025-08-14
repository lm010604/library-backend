class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user
  has_many :review_likes, dependent: :destroy
  has_many :comments, dependent: :destroy

  validates :rating, presence: { message: "Please select a rating." }, inclusion: { in: 1..5 }
  # validates :body, presence: true
  validates :user_id, uniqueness: { scope: :book_id, message: "has already reviewed this book" }

  before_save :strip_html_from_body

  private

  def strip_html_from_body
    self.body = ActionController::Base.helpers.sanitize(body, tags: [], attributes: [])
  end
end
