# frozen_string_literal: true

module Types
  class QueryType < Types::BaseObject
    field :node, Types::NodeType, null: true, description: "Fetches an object given its ID." do
      argument :id, ID, required: true, description: "ID of the object."
    end

    def node(id:)
      context.schema.object_from_id(id, context)
    end

    field :nodes, [Types::NodeType, null: true], null: true, description: "Fetches a list of objects given a list of IDs." do
      argument :ids, [ID], required: true, description: "IDs of the objects."
    end

    def nodes(ids:)
      ids.map { |id| context.schema.object_from_id(id, context) }
    end

    field :books, [Types::BookType], null: false

    def books
      Book.all
    end

    field :book, Types::BookType, null: true do
      argument :id, ID, required: true
    end

    def book(id:)
      Book.find_by(id: id)
    end

    field :reviews, [Types::ReviewType], null: false

    def reviews
      Review.all
    end

    field :current_user, Types::UserType, null: true

    def current_user
      context[:current_user]
    end
  end
end
