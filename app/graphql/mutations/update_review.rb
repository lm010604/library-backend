# frozen_string_literal: true

module Mutations
  class UpdateReview < BaseMutation
    argument :id, ID, required: true
    argument :rating, Integer, required: false
    argument :body, String, required: false

    field :review, Types::ReviewType, null: false

    def resolve(id:, **attributes)
      review = Review.find(id)
      review.update!(attributes.compact)
      { review: review }
    end
  end
end
