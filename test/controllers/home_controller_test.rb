require 'test_helper'

class HomeControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers
  test "should redirect to profile" do
    sign_in users(:one)
    get '/home/index'
    assert_response :redirect
  end

end
