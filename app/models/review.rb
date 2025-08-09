class Review < ApplicationRecord
  belongs_to :book
  belongs_to :user
  validates :rating, inclusion: { in: 1..5 }
  validates :body, presence: true
end
