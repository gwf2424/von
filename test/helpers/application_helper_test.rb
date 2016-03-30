require 'test_helper'

class ApplicationHelperTest < ActionView::TestCase
	test "full title helper" do
		assert_equal full_title, "Von's website 1@11. 1*6"
		assert_equal full_title("Help"), "Help | Von's website 1@11. 1*6"
	end
end