# frozen_string_literal: true

module Types
  class CommentType < Types::BaseObject
    implements Types::NodeType

    field :body, String, null: false
    field :user, Types::UserType, null: false
    field :review, Types::ReviewType, null: false
    field :parent, Types::CommentType, null: true
    field :replies, [Types::CommentType], null: false

    def user
      object.user
    end

    def review
      object.review
    end

    def parent
      object.parent
    end

    def replies
      object.replies
    end
  end
end
