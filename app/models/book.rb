class Book < ApplicationRecord
  belongs_to :user
  before_create :set_date_added
  enum :read, { read: 0, not_read_yet: 1 }
  validates :title, presence: true
  validates :author, presence: true
  validates :pages, presence: true
  validates :read, presence: true
  private
  def set_date_added
    self.date_added ||= Date.today
  end
end
