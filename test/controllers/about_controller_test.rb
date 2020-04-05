require 'test_helper'

class AboutControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers
  test "Page can be loaded" do
    sign_in users(:one)
    get '/about'
    assert_response :success
  end
end
