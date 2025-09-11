# frozen_string_literal: true

module Mutations
  class DeleteComment < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false

    def resolve(id:)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Authentication required" unless user
      comment = Comment.find(id)
      raise GraphQL::ExecutionError, "Not authorized" unless comment.user == user
      success = comment.destroy.destroyed?
      { success: success }
    end
  end
end
