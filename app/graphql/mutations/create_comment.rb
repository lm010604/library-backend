# frozen_string_literal: true

module Mutations
  class CreateComment < BaseMutation
    argument :review_id, ID, required: true
    argument :body, String, required: true
    argument :parent_id, ID, required: false

    field :comment, Types::CommentType, null: false

    def resolve(review_id:, body:, parent_id: nil)
      comment = Comment.create!(review_id: review_id, body: body, parent_id: parent_id, user: context[:current_user])
      { comment: comment }
    end
  end
end
