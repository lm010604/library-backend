# frozen_string_literal: true

module Types
  class ReviewType < Types::BaseObject
    implements Types::NodeType

    field :rating, Integer, null: false
    field :body, String, null: true
    field :user, Types::UserType, null: false
    field :book, Types::BookType, null: false

    def user
      object.user
    end

    def book
      object.book
    end
  end
end
