require 'test_helper'

class AnnouncementsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @announcement = announcements(:one)
    @admin = users(:admin)
  end

  test "should get index" do
    get announcements_url
    assert_response :success
  end

  test "should get new" do
    sign_in @admin
    get new_announcement_url
    assert_response :success
  end

  test "should create announcement" do
    sign_in @admin
    assert_difference('Announcement.count') do
      post announcements_url, params: { announcement: { body: @announcement.body, title: @announcement.title, user_id: @admin.id } }
    end

    assert_redirected_to announcement_url(Announcement.last)
  end

  test "should show announcement" do
    get announcement_url(@announcement)
    assert_response :success
  end

  test "should get edit" do
    sign_in @admin
    get edit_announcement_url(@announcement)
    assert_response :success
  end

  test "should update announcement" do
    sign_in @admin
    patch announcement_url(@announcement), params: { announcement: { body: @announcement.body, title: @announcement.title, user_id: @admin.id } }
    assert_redirected_to announcement_url(@announcement)
  end

  test "should destroy announcement" do
    sign_in @admin
    assert_difference('Announcement.count', -1) do
      delete announcement_url(@announcement)
    end

    assert_redirected_to announcements_url
  end
end
