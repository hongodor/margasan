require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @project = projects(:one)
    @user = users(:user)
    @another_user = users(:another)
  end

  test "should get index" do
    get projects_path
    assert_response :success
  end

  test "should get new" do
    sign_in @user
    get new_project_path
    assert_response :success
  end

  test "should get show" do
    get project_path(@project)
    assert_response :success
  end

  test "should get create" do
    sign_in @user
    assert_difference('Project.count') do
      post projects_path, params: { project: { name: "Virgin Island", description: "test description", author: "test author" }}
    end
    assert_redirected_to project_path(Project.last)
  end

  test "should get edit" do
    sign_in @user
    get edit_project_path(@project)
    assert_response :success
  end

  test "should get update" do
    sign_in @user
    get edit_project_path(@project)
    patch project_path(@project), params: { project: { name: "Virgin Island", description: "description", author: "Me" }}
    assert_redirected_to @project
    @project.reload
    assert_equal "Virgin Island",  @project.name
    assert_equal "description",  @project.description
    assert_equal "Me",  @project.author
    assert_equal @user,  @project.user
  end

  test "should get destroy" do
    sign_in @user
    assert_difference('Project.count', -1) do
      delete project_path(@project)
    end
    assert_redirected_to projects_url
  end

end
