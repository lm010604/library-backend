# frozen_string_literal: true

module Types
  class BookType < Types::BaseObject
    implements Types::NodeType

    field :title, String, null: false
    field :author, String, null: false
    field :average_rating, Float, null: true
    field :reviews, [Types::ReviewType], null: false
    field :category, Types::CategoryType, null: false
    field :owners, [Types::UserType], null: false

    def reviews
      object.reviews
    end

    def category
      object.category
    end

    def owners
      object.owners
    end

    def average_rating
      object.average_rating
    end
  end
end
