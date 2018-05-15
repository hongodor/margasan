require 'test_helper'

class ChapterTest < ActiveSupport::TestCase

  def setup
    @chapter = chapters(:chapter_one)
  end

  test "should be valid" do
    assert @chapter.valid?
  end

  test "project_id be valid" do
    @chapter.project_id = nil
    assert_not @chapter.valid?
  end

  test "name be valid" do
    @chapter.name = nil
    assert_not @chapter.valid?
  end
end
