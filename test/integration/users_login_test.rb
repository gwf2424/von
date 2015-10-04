require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:gwf2) # 使用固件.yml中的模型!
	end

	test "login with remembering" do
		log_in_as(@user, remember_me: '1')
		assert_not_nil cookies['remember_token']
		assert_equal assigns(:user).remember_token, cookies['remember_token']
	end

	# 不记住我，cookies里应该是空的
	test "login without remembering" do
		log_in_as(@user, remember_me: '0')
		assert_nil cookies['remember_me_token']
	end

	test "login with valid information" do
		get login_path
		post login_path, session: { email: @user.email, password: '123456'}
		assert_redirected_to @user
		follow_redirect!
		assert_template 'users/show'
		assert_select "a[href=?]", login_path, count: 0
		assert_select "a[href=?]", logout_path
		assert_select "a[href=?]", user_path(@user)
	end

	test "login with valid info followed by logout" do
		get login_path
		post login_path, session: { email: @user.email, password: '123456'}
		assert is_logged_in?
		assert_redirected_to @user
		follow_redirect!
		assert_template 'users/show'
		assert_select "a[href=?]", login_path, count: 0
		assert_select "a[href=?]", logout_path
		assert_select "a[href=?]", user_path(@user)
		delete logout_path
		assert_not is_logged_in?
		assert_redirected_to root_url
		delete logout_path
		follow_redirect!
		assert_select "a[href=?]", login_path
		assert_select "a[href=?]", logout_path, count:0
		assert_select "a[href=?]", user_path(@user), count:0
	end

end
