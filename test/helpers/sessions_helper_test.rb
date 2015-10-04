require 'test_helper'

class SessionsHelperTest < ActionView::TestCase
	
	def setup
		@user = users(:gwf2)
		remember(@user)
	end

	#没有session会话的情况下，获取用户
	#如第二次打开浏览器之后，session是nil，但是cookies里有记录
	test "current_user returns right user when sessions is nil" do
		assert_equal @user, current_user
		assert is_logged_in?
	end

	#if(user && user.authenticated?(cookies[:remember_token]))
	test "current_user returns nil when remember digest is wrong" do
		@user.update_attribute(:remember_digest, User.digest(User.new_token))
		assert_nil current_user
	end


end