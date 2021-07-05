require "test_helper"

class SigningUpAUserTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = User.create(username: "johndoe", email: "johndoe@example.com",
                              password: "password", admin: true)
    @regular_user = User.create(username: "johndoe1", email: "johndoe1@example.com",
                              password: "password")
  end

  test "get to sign in page and signing in a regular user" do
    get '/signup'
    assert_response :success
    sign_in_as(@regular_user)
    assert_response :redirect
    follow_redirect!
    assert_match "johndoe1", response.body
  end

  test "get to sign in page and signin in as admin" do
    get '/signup'
    assert_response :success
    sign_in_as(@admin_user)
    assert_response :redirect
    follow_redirect!
    assert_match "johndoe", response.body
  end

  test "get to sign up page and signing up a regular user" do
    get '/signup'
    assert_response :success
    assert_difference 'User.count', 1 do 
      post users_path, params: { user: { username: "New user", email: "newuser@example.com",
                                        password: "password" } }
      assert_response :redirect
    end
    follow_redirect!
    assert_response :success
    assert_template 'users/show'
    assert_match "New user", response.body
  end

end
