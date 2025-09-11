# frozen_string_literal: true

module Mutations
  class UpdateComment < BaseMutation
    argument :id, ID, required: true
    argument :body, String, required: false

    field :comment, Types::CommentType, null: false

    def resolve(id:, body: nil)
      comment = Comment.find(id)
      comment.update!(body: body) if body
      { comment: comment }
    end
  end
end
