# frozen_string_literal: true

module Types
  class LibraryEntryType < Types::BaseObject
    implements Types::NodeType

    field :status, String, null: false
    field :date_added, GraphQL::Types::ISO8601Date, null: false
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
