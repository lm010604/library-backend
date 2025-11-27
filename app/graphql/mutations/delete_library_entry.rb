# frozen_string_literal: true

module Mutations
  class DeleteLibraryEntry < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false

    def resolve(id:)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Authentication required" unless user
      entry = LibraryEntry.find(id)
      raise GraphQL::ExecutionError, "Not authorized" unless entry.user == user
      success = entry.destroy.destroyed?
      { success: success }
    end
  end
end
