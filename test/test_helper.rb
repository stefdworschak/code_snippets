ENV['RAILS_ENV'] ||= 'test'
require_relative '../config/environment'
require 'rails/test_help'
require "minitest/reporters"
Minitest::Reporters.use!

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Devise login helpers
  # include Devise::Test::IntegrationHelpers
  # include Warden::Test::Helpers

  # def sign_in(user)
  #   if integration_test?
  #     login_as(user, :scope => :user)
  #   else
  #     login_as(user)
  #   end
  # end
  # End Devise login helpers
end
