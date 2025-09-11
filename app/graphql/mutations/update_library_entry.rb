# frozen_string_literal: true

module Mutations
  class UpdateLibraryEntry < BaseMutation
    argument :id, ID, required: true
    argument :status, String, required: false
    argument :date_added, GraphQL::Types::ISO8601Date, required: false

    field :library_entry, Types::LibraryEntryType, null: false

    def resolve(id:, **attributes)
      entry = LibraryEntry.find(id)
      entry.update!(attributes.compact)
      { library_entry: entry }
    end
  end
end
