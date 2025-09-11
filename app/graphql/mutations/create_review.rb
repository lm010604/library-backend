# frozen_string_literal: true

module Mutations
  class CreateReview < BaseMutation
    argument :book_id, ID, required: true
    argument :rating, Integer, required: true
    argument :body, String, required: false

    field :review, Types::ReviewType, null: false

    def resolve(book_id:, rating:, body: nil)
      review = Review.create!(book_id: book_id, rating: rating, body: body, user: context[:current_user])
      { review: review }
    end
  end
end
