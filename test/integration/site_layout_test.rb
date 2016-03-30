require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:gwf2)
	end

	test "layout links" do
		get root_path
		assert_template 'static_pages/home'
		assert_select "a[href=?]", root_path, count: 3
		assert_select "a[href=?]", help_path
		assert_select "a[href=?]", about_path
		assert_select "a[href=?]", contact_path
		get signup_path
		assert_select "title", full_title("Sign up")
	end

	test "layout before logged" do
		get root_path
		assert_template 'static_pages/home'
		assert_select 'a', count: 14
		assert_nil session[:forwarding_url]
		assert_nil cookies['remember_token']
	end

	test "layout after logged at home" do
		log_in_as(@user, remember_me: '1')
		assert_equal cookies['remember_token'], assigns(:user).remember_token
		assert_redirected_to @user
		follow_redirect!
		assert_template 'users/show'
		#assert_select 'a', count: 13
	end

end
