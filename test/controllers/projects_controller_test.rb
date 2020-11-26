require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  test "案件⼀覧画⾯が表示できること" do
    get projects_path
    assert_response :success
  end

  # test "should get show" do
  #   get projects_show_url
  #   assert_response :success
  # end

  test "新規案件追加画⾯が表示できること" do
    get new_project_path
    assert_response :success
  end

  # test "should get create" do
  #   get projects_create_url
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get projects_edit_url
  #   assert_response :success
  # end

  # test "should get update" do
  #   get projects_update_url
  #   assert_response :success
  # end

  # test "should get destroy" do
  #   get projects_destroy_url
  #   assert_response :success
  # end

end
