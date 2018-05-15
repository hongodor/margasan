require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  def setup
    @project = projects(:one)
    @user = users(:user)
    @another_user = users(:another)
    @test_project = { name: "test project name",
                      description: "test project description",
                      author: "test project author"}
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
      post projects_path, params: {project: @test_project}
    end
    assert_redirected_to project_path(Project.last)
  end

  # user is owner
  test "should get edit" do
    sign_in @user
    get edit_project_path(@project)
    assert_response :success
  end

  # user is not owner
  test "should get edit as incorrect user" do
    sign_in @another_user
    get edit_project_path(@project)
    assert_user_not_authorized
  end

  test "should get update" do
    sign_in @user
    patch project_path(@project), params: {project: @test_project }
    assert_redirected_to @project
    @project.reload
    assert_equal "test project name", @project.name
    assert_equal "test project description", @project.description
    assert_equal "test project author", @project.author
    assert_equal @user, @project.user
  end

  test "should get update as incorrect user" do
    sign_in @another_user
    patch project_path(@project), params: {project: @test_project}
    assert_user_not_authorized
  end

  test "should get destroy" do
    sign_in @user
    assert_difference('Project.count', -1) do
      delete project_path(@project)
    end
    assert_redirected_to projects_url
  end

  test "should get destroy as incorrect user" do
    sign_in @another_user
    assert_no_difference('Project.count') do
      delete project_path(@project)
    end
    assert_user_not_authorized
  end
end
