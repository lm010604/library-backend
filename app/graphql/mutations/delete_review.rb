# frozen_string_literal: true

module Mutations
  class DeleteReview < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false

    def resolve(id:)
      review = Review.find(id)
      success = review.destroy.destroyed?
      { success: success }
    end
  end
end
