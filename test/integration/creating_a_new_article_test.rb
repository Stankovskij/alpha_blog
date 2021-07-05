require "test_helper"

class CreatingANewArticleTest < ActionDispatch::IntegrationTest

  setup do
    @admin_user = User.create(username: "johndoe", email: "johndoe@example.com",
                              password: "password", admin: true)
    @regular_user = User.create(username: "johndoe", email: "johndoe@example.com",
                            password: "password")
  end

  test "get article create page creating new article as regular user" do
    sign_in_as(@regular_user)
    get '/articles/new'
    assert_response :success
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: 'Audiiii', description: 'New fast audi' } }
      assert_response :redirect
    end
      follow_redirect!
      assert_response :success
      assert_match 'Audiiii', response.body
      assert_match 'New fast audi', response.body
  end

  test "get article create page creating new article as admin user" do
    sign_in_as(@admin_user)
    get '/articles/new'
    assert_response :success
    assert_difference 'Article.count', 1 do
      post articles_path, params: { article: { title: 'Audiiii', description: 'New fast audi' } }
      assert_response :redirect
    end
      follow_redirect!
      assert_response :success
      assert_match 'Audiiii', response.body
      assert_match 'New fast audi', response.body
  end

end
