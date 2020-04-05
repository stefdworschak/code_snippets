require 'test_helper'

class SnippetTest < ActiveSupport::TestCase
  test "All snippet details need to be provided for successful save" do
    snippet = Snippet.new(code: "Test code",
                           user_id: 1)
    assert_equal(false, snippet.save, 
                 "Expected save to fail because of missing title, but snippet was saved anyway.")
  end

  test "Snippet needs valid User" do
    snippet = Snippet.new(code: "Test code", title: "Test Title", user_id: -1)
    assert_equal(false, snippet.save, "Expected to fail because of an invalid user_id, but passed anyway")
  end 

  test "Snippet must be under 512 characters" do
    code_text = """Lorem ipsum dolor sit amet, consectetur adipiscing elit. 
                Morbi facilisis nec leo vitae vestibulum. Sed massa nulla, 
                volutpat nec ex vel, rutrum condimentum libero. Suspendisse 
                potenti. Class aptent taciti sociosqu ad litora torquent 
                per conubia nostra, per inceptos himenaeos. Phasellus nisl 
                mauris, luctus in magna eget, suscipit porta odio. Pellentesque 
                eu lacus mollis, pharetra quam in, sagittis est. Phasellus mi 
                risus, imperdiet vitae augue vitae, ullamcorper placerat turpis. 
                Donec ultricies ultricies cursus."""
    snippet = Snippet.new(code: code_text, title: "Test Title", user_id: 1)
    assert_equal(false, snippet.save, "Expected to fail because the text is more than 512 chars, but passed anyway")
  end 

  test "Snippet can be created" do
    snippet = Snippet.new(code: "Test code", title: "Test Title", user_id: 1)
    assert_equal(true, snippet.save, "Expected snippet to be saved, but failed")
  end
end
