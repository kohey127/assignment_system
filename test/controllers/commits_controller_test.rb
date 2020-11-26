require 'test_helper'

class CommitsControllerTest < ActionDispatch::IntegrationTest
  test "トップ画⾯が表示できること" do
    get root_path
    assert_response :success
    assert_select "title", "トップ | Assign Management System"
  end

  # test "should get show" do
  #   get commits_show_url
  #   assert_response :success
  # end

  test "新規案件追加画⾯が表示できること" do
    get new_commit_path
    assert_response :success
    assert_select "title", "稼働率新規作成 | Assign Management System"
  end

  # test "should get create" do
  #   get commits_create_url
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get commits_edit_url
  #   assert_response :success
  # end

  # test "should get update" do
  #   get commits_update_url
  #   assert_response :success
  # end

  # test "should get destroy" do
  #   get commits_destroy_url
  #   assert_response :success
  # end

end
