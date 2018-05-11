require 'test_helper'

class ProjectsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @project = projects(:one)
  end

  test "should get index" do
    get projects_path
    assert_response :success
  end

  test "should get new" do

    get new_project_path
    assert_response :success
  end

  test "should get show" do

    get project_path(@project)
    assert_response :success
  end

  test "should get create" do

    assert_difference('Project.count') do
      post projects_path, params: { project: { name: "Virgin Island", description: "test description", author: "test author" }}
    end

    assert_redirected_to project_path(Project.last)
  end

  test "should get edit" do

    get edit_project_path(@project)
    assert_response :success
  end

  test "should get update" do

    patch project_path(@project), params: { project: { name: "Virgin Island", description: @project.description, author: "Me" }}

    assert_redirected_to @project
    @project.reload
    assert_equal "Virgin Island",  @project.name
    assert_equal "Me",  @project.author
  end

  test "should get destroy" do
    assert_difference('Project.count', -1) do
      delete project_path(@project)
    end

    assert_redirected_to projects_url
  end

end
