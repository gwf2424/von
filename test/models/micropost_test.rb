require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
	def setup
		@user = users(:gwf2)
		@micropost = @user.microposts.build(content: "Lorem ipsum")
	end

	test "s b valid" do
		assert @micropost.valid?
	end

	test "user_id should be present" do
		@micropost.user_id = nil
		assert_not @micropost.valid?
	end

	test "content sb present" do
		@micropost.content = "   "
		assert_not @micropost.valid?
	end

	test "content sb at most 140 cs" do
		@micropost.content = "c" * 141
		assert_not @micropost.valid?
	end

	test "order sb the most recent" do
		assert_equal Micropost.first, microposts(:most_recent)
	end
end
