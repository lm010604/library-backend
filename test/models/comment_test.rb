require "test_helper"

class CommentTest < ActiveSupport::TestCase
  test "body is required" do
    comment = Comment.new(user: users(:one), review: reviews(:one))
    assert_not comment.valid?
    assert_includes comment.errors[:body], "can't be blank"
  end

  test "sanitizes html from body" do
    comment = Comment.create!(user: users(:one), review: reviews(:one), body: "<b>Hello</b>")
    assert_equal "Hello", comment.body
  end

  test "can reply to a comment" do
    parent = comments(:one)
    reply = Comment.create!(user: users(:two), review: reviews(:one), body: "Reply", parent: parent)
    assert_equal parent, reply.parent
    assert_includes parent.replies, reply
  end
end
