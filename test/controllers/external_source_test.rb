require 'test_helper'
require 'external_user_info_adapter'

class AboutControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers
  setup do
    sign_in users(:one)
    @reputation = ExternalUserInfoAdapter.instance()
    @profile1 = profiles(:one)
    @profile2 = profiles(:two)
    @profile3 = profiles(:three)
  end

  test "Set Settings" do
    settings = {
        "github_api_user" => ENV['GITHUB_API_USER'],
        "github_api_token" => ENV['GITHUB_API_TOKEN'],
        "stackoverflow_key" => ENV['STACKOVERFLOW_KEY']
    }
    @reputation.set_settings(settings)
    assert_equal(@reputation.get_settings(), settings, 
                 "Expected the reputation instance to have the settings, but were not set.")
  end

  test "Get GitHub Avatar" do
    avatar = @reputation.get_user_avatar_url(1)
    assert_not_nil(avatar, "Expected the avatar url to be returned, but instead returned nil")
  end

  test "Get StackOverflow Avatar" do
    avatar = @reputation.get_user_avatar_url(2)
    assert_not_nil(avatar, "Expected the avatar url to be returned, but instead returned nil")
  end

  test "Get Get GitHub Reputation" do
    github_rep = @reputation.get_github_data(@profile1.github_name)
    assert_equal("200", github_rep['status'],
                 "Expected GitHub user stats to be retrieved, but got #{github_rep['status']} error")
  end

  test "Get Get StackOverflow Reputation" do
    stackoverflow_rep = @reputation.get_github_data(@profile1.stackoverflow_name)
    assert_equal("200", stackoverflow_rep['status'],
    "Expected StackOverflow user stats to be retrieved, but got #{stackoverflow_rep['status']} error")
  end

  test "Get Combined Reputation" do
    combined_rep = @reputation.get_user_reputation(1)
    assert_equal("200", combined_rep['status'],
    "Expected StackOverflow user stats to be retrieved, but got #{combined_rep['status']} error")

  end

end
