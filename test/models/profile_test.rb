require 'test_helper'

class ProfileTest < ActiveSupport::TestCase
  test "Display Name needs to be provided" do
    profile = Profile.new(user_id: 1)
    assert_equal(false, profile.save, 
                 "Expected save to fail because of missing display_name, but profile was saved anyway.")
  end

  test "Snippet needs valid User" do
    profile = Profile.new(display_name: "Test User", user_id: -1)
    assert_equal(false, profile.save, "Expected to fail because of an invalid user_id, but passed anyway")
  end 

  test "Snippet can be created" do
    profile = Profile.new(display_name: "Test User", user_id: 1)
    assert_equal(true, profile.save, "Expected profile to save, but failed")
  end
end
