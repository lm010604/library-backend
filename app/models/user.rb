class User < ApplicationRecord
  has_secure_password

  has_many :library_entries, dependent: :destroy
  has_many :books, through: :library_entries
  has_many :reviews, dependent: :destroy

  validates :password, length: { minimum: 6 }, if: -> { password.present? }
  validates :name,  presence: true
  validates :email, presence: true, uniqueness: true
end
