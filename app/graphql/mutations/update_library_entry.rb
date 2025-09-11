# frozen_string_literal: true

module Mutations
  class UpdateLibraryEntry < BaseMutation
    argument :id, ID, required: true
    argument :status, String, required: false
    argument :date_added, GraphQL::Types::ISO8601Date, required: false

    field :library_entry, Types::LibraryEntryType, null: false

    def resolve(id:, **attributes)
      user = context[:current_user]
      raise GraphQL::ExecutionError, "Authentication required" unless user
      entry = LibraryEntry.find(id)
      raise GraphQL::ExecutionError, "Not authorized" unless entry.user == user
      entry.update!(attributes.compact)
      { library_entry: entry }
    end
  end
end
