require 'test_helper'

class EmployeesControllerTest < ActionDispatch::IntegrationTest
  test "社員⼀覧画⾯が表示できること" do
    get employees_path
    assert_response :success
    assert_select "title", "社員一覧 | Assign Management System"
  end

  # test "should get show" do
  #   get employees_show_url
  #   assert_response :success
  # end

  test "新規社員追加画⾯が表示できること" do
    get new_employee_path
    assert_response :success
    assert_select "title", "社員新規作成 | Assign Management System"
  end

  # test "should get create" do
  #   get employees_create_url
  #   assert_response :success
  # end

  # test "should get edit" do
  #   get employees_edit_url
  #   assert_response :success
  # end

  # test "should get update" do
  #   get employees_update_url
  #   assert_response :success
  # end

  # test "should get destroy" do
  #   get employees_destroy_url
  #   assert_response :success
  # end

end
