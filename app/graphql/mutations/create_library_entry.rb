# frozen_string_literal: true

module Mutations
  class CreateLibraryEntry < BaseMutation
    argument :book_id, ID, required: true
    argument :status, String, required: false
    argument :date_added, GraphQL::Types::ISO8601Date, required: false

    field :library_entry, Types::LibraryEntryType, null: false

    def resolve(book_id:, status: nil, date_added: nil)
      entry = LibraryEntry.create!(book_id: book_id, status: status, date_added: date_added, user: context[:current_user])
      { library_entry: entry }
    end
  end
end
