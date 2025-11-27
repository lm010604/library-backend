# frozen_string_literal: true

module Mutations
  class UpdateComment < BaseMutation
    argument :id, ID, required: true
    argument :body, String, required: false

    field :comment, Types::CommentType, null: false

    def resolve(id:, body: nil)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Authentication required" unless user
      comment = Comment.find(id)
      raise GraphQL::ExecutionError, "Not authorized" unless comment.user == user
      comment.update!(body: body) if body
      { comment: comment }
    end
  end
end
