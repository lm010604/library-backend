class Comment < ApplicationRecord
  belongs_to :user
  belongs_to :review
  belongs_to :parent, class_name: "Comment", optional: true
  has_many :replies, class_name: "Comment", foreign_key: "parent_id", dependent: :destroy

  validates :body, presence: true

  before_validation :limit_depth
  before_save :strip_html_from_body

  private

  def strip_html_from_body
    self.body = ActionController::Base.helpers.sanitize(body, tags: [], attributes: [])
  end

  def limit_depth
    self.parent = parent.parent if parent&.parent
  end
end
