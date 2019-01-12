require 'test_helper'

class ChaptersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers


  def setup
    @first_chapter = chapters(:chapter_one)
    file = fixture_file_upload(Rails.root.join('test/fixtures/files', 'Map043.json'))
    @test_chapter = { chapter_file: [file]}
  end

  test "should get show" do
    get chapter_path(@first_chapter)
    assert_response :success
  end

  # user is owner
  test "should create as user" do
    sign_in users(:user)
    assert_difference('Chapter.count') do
     post project_chapters_path(@first_chapter.project), params: { chapter: @test_chapter  }
    end
    assert_redirected_to Chapter.last.project
    assert_equal "Map043.json", Chapter.last.name
    assert_equal "Map043.json", Chapter.last.filename
  end

  # user is not owner
  test "should create as incorrect user" do
    sign_in users(:another)
    assert_no_difference('Chapter.count') do
      post project_chapters_path(@first_chapter.project), params: { chapter: @test_chapter}
    end
    assert_user_not_authorized
  end

  test "should destroy as user" do
    sign_in users(:user)
    assert_difference('Chapter.count',-1) do
      delete chapter_path(@first_chapter)
    end
    assert_redirected_to @first_chapter.project
  end

  test "should destroy as incorrect user" do
    sign_in users(:another)
    assert_no_difference('Chapter.count') do
      delete chapter_path(@first_chapter)
    end
    assert_user_not_authorized
  end
end
