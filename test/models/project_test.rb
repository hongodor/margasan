require 'test_helper'

class ProjectTest < ActiveSupport::TestCase

  def setup
    @project = projects(:one)
  end

  test "should be valid" do
     assert  @project.valid?
  end

end
