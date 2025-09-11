# frozen_string_literal: true

module Mutations
  class CreateReview < BaseMutation
    argument :book_id, ID, required: true
    argument :rating, Integer, required: true
    argument :body, String, required: false

    field :review, Types::ReviewType, null: false

    def resolve(book_id:, rating:, body: nil)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Authentication required" unless user
      review = Review.create!(book_id: book_id, rating: rating, body: body, user: user)
      { review: review }
    end
  end
end
