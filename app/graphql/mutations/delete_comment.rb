# frozen_string_literal: true

module Mutations
  class DeleteComment < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false

    def resolve(id:)
      comment = Comment.find(id)
      success = comment.destroy.destroyed?
      { success: success }
    end
  end
end
