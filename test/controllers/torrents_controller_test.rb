# frozen_string_literal: true

require "test_helper"

class TorrentsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  setup do
    @torrent = torrents(:one)
    @user = users(:user)
    @category = categories(:movies)
  end

  test "should get index" do
    sign_in @user
    get torrents_url
    assert_response :success
  end

  test "should get new" do
    sign_in @user
    get new_torrent_url(category_id: @category.id)
    assert_response :success
  end

  # TODO:
  # test "should create torrent" do
  #   assert_difference('Torrent.count') do
  #     post torrents_url, params: { torrent: {  } }
  #   end

  #   assert_redirected_to torrent_url(Torrent.last)
  # end

  test "should find with search" do
    sign_in @user
    get torrents_url({name: "2"})
    assert_response :success
    assert_equal assigns(:releases).first, Release.where(name: "Release 2").first
  end

  test "should show torrent" do
    sign_in @user
    get torrent_url(@torrent)
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get edit_torrent_url(@torrent)
    assert_response :success
  end

  # test "should update torrent" do
  #   patch torrent_url(@torrent), params: { torrent: {  } }
  #   assert_redirected_to torrent_url(@torrent)
  # end

  # test "should destroy torrent" do
  #   assert_difference('Torrent.count', -1) do
  #     delete torrent_url(@torrent)
  #   end

  #   assert_redirected_to torrents_url
  # end
end
