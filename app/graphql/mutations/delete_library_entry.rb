# frozen_string_literal: true

module Mutations
  class DeleteLibraryEntry < BaseMutation
    argument :id, ID, required: true

    field :success, Boolean, null: false

    def resolve(id:)
      entry = LibraryEntry.find(id)
      success = entry.destroy.destroyed?
      { success: success }
    end
  end
end
