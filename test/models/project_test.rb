require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  def setup
    @project = projects(:one)
  end

  test "should be valid" do
     assert  @project.valid?
  end

  test "description should be max 140 chars" do
    @project.description = "a" * 141
    assert_not @project.valid?
  end
end
