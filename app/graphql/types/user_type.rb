# frozen_string_literal: true

module Types
  class UserType < Types::BaseObject
    implements Types::NodeType

    field :name, String, null: false
    field :email, String, null: false

    def email
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Not authorized" unless user == object
      object.email
    end
    field :books, [Types::BookType], null: false
    field :reviews, [Types::ReviewType], null: false
    field :categories, [Types::CategoryType], null: false

    def books
      object.books
    end

    def reviews
      object.reviews
    end

    def categories
      object.categories
    end
  end
end
