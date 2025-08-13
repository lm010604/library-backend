require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @category = categories(:one)
  end

  test "paginates search results" do
    35.times do |i|
      Book.create!(title: "Example #{i}", author: "Author #{i}", category: @category)
    end

    get books_path(q: "Example")
    assert_response :success
    assert_select ".book-card", 30

    get books_path(q: "Example", page: 1)
    assert_response :success
    assert_select ".book-card", 5
  end

  test "paginates favorite category results" do
    user = User.create!(name: "Test", email: "test@example.com", password: "secret")
    user.categories << @category
    35.times do |i|
      Book.create!(title: "Fav #{i}", author: "Auth #{i}", category: @category)
    end

    post session_path, params: { email: user.email, password: "secret" }
    get favorites_books_path(category_id: @category.id)
    assert_response :success
    assert_select ".book-card", 30

    get favorites_books_path(category_id: @category.id, page: 1)
    assert_response :success
    assert_select ".book-card", 5
  end
end

