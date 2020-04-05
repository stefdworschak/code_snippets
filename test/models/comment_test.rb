require 'test_helper'

class CommentTest < ActiveSupport::TestCase
  test "All comment details need to be provided for successful save" do
    comment = Comment.new(comment_body: "Test Comment",
                           user_id: 1)
    assert_equal(false, comment.save, "Expected comment not to be saved, but comment was saved.")
  end

  test "Comment needs valid Snippet" do
    comment = Comment.new(comment_body: "Test Comment", snippet_id: -1, user_id: 1)
    assert_equal(false, comment.save, 
                 "Expected to fail because of an invalid snippet_id, but passed anyway")
  end

  test "Comment needs valid User" do
    comment = Comment.new(comment_body: "Test Comment", snippet_id: 1, user_id: -1)
    assert_equal(false, comment.save, 
                 "Expected to fail because of an invalid  user_id, but passed anyway")
  end

  test "Comment can be created" do
    comment = Comment.new(comment_body: "Test Comment", snippet_id: 1, user_id: 1)
    assert_equal(true, comment.save, "Expected comment to be saved, but failed")
  end
end
