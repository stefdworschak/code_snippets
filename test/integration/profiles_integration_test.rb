require 'test_helper'

class ProfilesIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers
  setup do
    #sign_in users(:four)
    #@user = users(:four)
  end

  test "can create a profile" do
    sign_in users(:four)
    @user = users(:four)
    get "/"
    assert_response :redirect
    follow_redirect!
    
    assert_select 'div.card-header', 'Create User Profile'
    post "/profiles",
    params: { profile: { display_name: "Test User 4", user_id: @user.id } }
    assert_response :redirect
    follow_redirect!
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'div.row.profile-row'
  end

  test "can edit a profile" do
    sign_in users(:one)
    @user = users(:one)
    @profile = Profile.new(display_name: "Test User", user_id: 1)
    @profile.save

    get "/"
    assert_response :redirect
    follow_redirect!
    assert_select 'div.row.profile-row'

    get "/profiles/#{@user.id}/edit"
    assert_response :success
    assert_select 'div.card-header', 'Update User Profile'

    patch profile_url(@profile),
    params: { profile: { display_name: "Test User 1 Updated", user_id: @user.id } }
    assert_response :redirect
    follow_redirect!
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'div.row.profile-row'
  end
end
