class User < ApplicationRecord
  has_secure_password

  has_many :library_entries, dependent: :destroy
  has_many :books, through: :library_entries
  has_many :reviews, dependent: :destroy
  has_many :review_likes, dependent: :destroy
  has_many :liked_reviews, through: :review_likes, source: :review
  has_many :user_categories
  has_many :favorite_categories, through: :user_categories, source: :category

  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :name,  presence: true,
                    format: { with: /\A[^0-9]*\z/, message: "cannot contain numbers" }
  validates :email, presence: true, uniqueness: true
end
