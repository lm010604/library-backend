class LibraryEntry < ApplicationRecord
  belongs_to :user
  belongs_to :book
  enum :status, { read: 0, not_read_yet: 1 }
  validates :user_id, uniqueness: { scope: :book_id }
  before_create { self.date_added ||= Date.today }

  before_validation :set_default_status, on: :create
  private
  def set_default_status
    self.status ||= :not_read_yet
  end
end
