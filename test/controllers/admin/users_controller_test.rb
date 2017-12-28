require 'test_helper'

class Admin::UsersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @admin = users(:admin)
  end

  test "should get index" do
    sign_in @admin
    get admin_users_url
    assert_response :success
  end

  test "should create user" do
    assert_difference('User.count') do
      sign_in @admin
      post admin_users_url, params: { user: { email: 'test2@example.com', username: 'test', password: "example" } }
    end

    assert_redirected_to admin_user_url(User.last)
  end
end
