require 'test_helper'

class AdminIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers
  test "only admin has access to manage users" do
    sign_in users(:two)
    get "/profiles"
    assert_response :redirect
  end


end
