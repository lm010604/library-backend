# frozen_string_literal: true

module Mutations
  class DeleteReview < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false

    def resolve(id:)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Authentication required" unless user
      review = Review.find(id)
      raise GraphQL::ExecutionError, "Not authorized" unless review.user == user
      success = review.destroy.destroyed?
      { success: success }
    end
  end
end
