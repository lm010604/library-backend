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
end

