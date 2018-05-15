ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  def assert_user_not_authorized
    assert_equal "You are not authorized to perform this action.", flash[:alert]
    assert_redirected_to(request.referrer || root_path)
  end
  # Add more helper methods to be used by all tests here...
end
