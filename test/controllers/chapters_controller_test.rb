require 'test_helper'

class ChaptersControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers


  def setup
    @first_chapter = chapters(:chapter_one)
    file = fixture_file_upload(Rails.root.join('test/fixtures/files', 'test.txt'), 'text/plain')
    @test_chapter = { name: "test chapter_name",
                      status: 0,
                      phrases_count: 40,
                      chapter_file: file }
  end

  test "should get show" do
    get chapter_path(@first_chapter)
    assert_response :success
  end

  # user is owner
  test "should create as user" do
    sign_in users(:user)
    assert_difference('Chapter.count') do
     post project_chapters_path(@first_chapter.project), params: { chapter: @test_chapter}
    end
    assert_redirected_to chapter_path(Chapter.last)
    assert_equal "test chapter_name", Chapter.last.name
    assert_equal "test.txt", Chapter.last.filename
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
