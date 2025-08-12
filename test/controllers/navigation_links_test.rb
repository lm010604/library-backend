require "test_helper"

class NavigationLinksTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create!(name: "Test User", email: "user@example.com", password: "password", password_confirmation: "password")
  end

  test "shows profile and sign out when logged in" do
    post session_url, params: { email: @user.email, password: "password" }
    get root_url
    assert_select "nav a", "My Profile"
    assert_select "nav a", "Sign out"
  end

  test "hides profile and sign out when logged out" do
    get root_url
    assert_select "nav a", { text: "My Profile", count: 0 }
    assert_select "nav a", { text: "Sign out", count: 0 }
  end
end
