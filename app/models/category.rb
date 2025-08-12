class Category < ApplicationRecord
  has_many :books
  has_many :user_categories
  has_many :users, through: :user_categories

  validates :name, presence: true, uniqueness: true
end
