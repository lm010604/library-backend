# frozen_string_literal: true

module Types
  class MutationType < Types::BaseObject
    field :create_review, mutation: Mutations::CreateReview
    field :update_review, mutation: Mutations::UpdateReview
    field :delete_review, mutation: Mutations::DeleteReview

    field :create_comment, mutation: Mutations::CreateComment
    field :update_comment, mutation: Mutations::UpdateComment
    field :delete_comment, mutation: Mutations::DeleteComment

    field :create_library_entry, mutation: Mutations::CreateLibraryEntry
    field :update_library_entry, mutation: Mutations::UpdateLibraryEntry
    field :delete_library_entry, mutation: Mutations::DeleteLibraryEntry
  end
end
