class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user
  has_many :review_likes, dependent: :destroy

  validates :rating, inclusion: { in: 1..5 }
  validates :body, presence: true

  before_save :strip_html_from_body

  private

  def strip_html_from_body
    self.body = ActionController::Base.helpers.sanitize(body, tags: [], attributes: [])
  end
end
