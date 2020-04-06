require 'test_helper'

class CommentsIntegrationTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers # <-- Include helpers
  setup do
    sign_in users(:one)
    @user = users(:one)
    @profile = Profile.new(display_name: "Test User", user_id: 1)
    @profile.save
    @snippet = Snippet.new(code: "Test", title: "Test", user_id: 1)
    @snippet.save
    @comment = comments(:one)
  end

  test "can create new comment" do
    get '/'
    assert_response :redirect
    follow_redirect!
    assert_select 'div.row.profile-row'

    assert_difference('Comment.count') do
      get "/snippets/#{@snippet.id}"
      post '/snippets/create_comment',
      params: { comment: { comment_body: @comment.comment_body, snippet_id: @comment.snippet_id, user_id: @user.id } }
    end
    
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'div.row.snippet-header-row'
  end

  test "can update existing comment" do
    @comment = Comment.new(comment_body: @comment.comment_body, snippet_id: @comment.snippet_id, user_id: @user.id)
    @comment.save

    get '/'
    assert_response :redirect
    follow_redirect!
    assert_select 'div.row.profile-row'

    patch "/comments/#{@comment.id}",
    params: { comment: { comment_body: "Change Comment" } }
    @comment = Comment.find(@comment.id)
    assert_equal(@comment.comment_body, "Change Comment",
                 "Expected comment_body to change, but did not change or not to the correct value")
    
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'div.row.snippet-header-row'
  end

  test "can delete a comment" do
    @comment = Comment.new(comment_body: @comment.comment_body, snippet_id: @comment.snippet_id, user_id: @user.id)
    @comment.save

    get "/snippets/#{@snippet.id}"
    assert_response :success
    assert_select 'div.row.snippet-header-row'
    
    assert_difference('Comment.count', -1) do
      delete "/comments/#{@comment.id}"
    end
    assert_response :redirect
    follow_redirect!
    assert_response :success
    assert_select 'div.row.snippet-header-row'
  end
end
