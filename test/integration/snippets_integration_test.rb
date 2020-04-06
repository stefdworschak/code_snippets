require 'test_helper'

class SnippetsIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers
  setup do
    sign_in users(:one)
    @user = users(:one)
    @profile = Profile.new(display_name: "Test User", user_id: 1)
    @profile.save
    @snippet = snippets(:one)
  end

  test "Create new snippet" do
    get '/'
    assert_response :redirect
    follow_redirect!
    assert_select 'div.row.profile-row'

    get '/snippets/new'
    assert_response :success

    assert_difference('Snippet.count') do
      post snippets_url,
      params: { snippet: { title: @snippet.title, code: @snippet.code, user_id: @user.id } }
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'div.row.snippet-header-row'
  end

  test "Show existing snippet" do
    @snippet = Snippet.new(title: @snippet.title, code: @snippet.code, user_id: @user.id)
    @snippet.save

    get "/snippets/#{@snippet.id}/edit"
    assert_response :success
    assert_select 'div.card.create-snippet'
  end

  test "Edit existing snippet" do
    @snippet = Snippet.new(title: @snippet.title, code: @snippet.code, user_id: @user.id)
    @snippet.save

    get "/snippets/#{@snippet.id}/edit"
    assert_response :success
    assert_select 'div.card.create-snippet'

    patch "/snippets/#{@snippet.id}",
    params: { snippet: { title: "Change Title", code: "Change Code" } }
    @snippet = Snippet.find(@snippet.id)
    assert_equal("Change Title", @snippet.title)
    assert_equal("Change Code", @snippet.code)

    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'div.row.snippet-header-row'
  end

  test "Delete existing snippet" do
    @snippet = Snippet.new(title: @snippet.title, code: @snippet.code, user_id: @user.id)
    @snippet.save

    get "/snippets/#{@snippet.id}"
    assert_response :success
    assert_select 'div.row.snippet-header-row'
    
    assert_difference('Snippet.count', -1) do
      delete "/snippets/#{@snippet.id}"
    end

    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'div.card.explore-snippets'
  end

end
