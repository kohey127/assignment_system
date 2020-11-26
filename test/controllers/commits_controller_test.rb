require 'test_helper'

class CommitsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get commits_index_url
    assert_response :success
  end

  test "should get show" do
    get commits_show_url
    assert_response :success
  end

  test "should get new" do
    get commits_new_url
    assert_response :success
  end

  test "should get create" do
    get commits_create_url
    assert_response :success
  end

  test "should get edit" do
    get commits_edit_url
    assert_response :success
  end

  test "should get update" do
    get commits_update_url
    assert_response :success
  end

  test "should get destroy" do
    get commits_destroy_url
    assert_response :success
  end

end
