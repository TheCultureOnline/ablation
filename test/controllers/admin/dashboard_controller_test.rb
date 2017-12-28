require 'test_helper'

class Admin::DashboardControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers
  
  setup do
    @admin = users(:admin)
  end

  test "should get dashboard" do
    sign_in @admin
    get admin_dashboard_url
    assert_response :success
  end

end
