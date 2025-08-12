require "test_helper"

class ProfilesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Test User", email: "user@example.com", password: "password", password_confirmation: "password")
    @cat1 = Category.create!(name: "Fantasy")
    @cat2 = Category.create!(name: "Sci-Fi")
    @user.categories << @cat1
  end

  test "redirects edit when not logged in" do
    get profile_url
    assert_redirected_to new_session_path
  end

  test "shows profile when logged in" do
    post session_url, params: { email: @user.email, password: "password" }
    get profile_url
    assert_response :success
  end

  test "updates profile" do
    post session_url, params: { email: @user.email, password: "password" }
    patch profile_url, params: { user: { name: "Updated", category_ids: [@cat2.id] } }
    assert_redirected_to profile_path
    @user.reload
    assert_equal "Updated", @user.name
    assert_equal [@cat2.id], @user.category_ids
  end
end
