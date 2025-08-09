class Book < ApplicationRecord
  has_many :reviews, dependent: :destroy
  has_many :library_entries, dependent: :destroy
  has_many :owners, through: :library_entries, source: :user

  validates :title,  presence: true
  validates :author, presence: true
  validates :pages,  presence: true

  def average_rating
    reviews.average(:rating)&.round(1)
  end
end
