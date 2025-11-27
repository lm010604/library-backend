# frozen_string_literal: true

module Types
  class CategoryType < Types::BaseObject
    implements Types::NodeType

    field :name, String, null: false
    field :books, [Types::BookType], null: false
    field :users, [Types::UserType], null: false

    def books
      object.books
    end

    def users
      object.users
    end
  end
end
