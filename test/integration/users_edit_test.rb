require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:gwf2)
	end

	test "unsuccessful edit" do
		log_in_as(@user)
		get edit_user_path(@user)
		patch user_path(@user), user: { name: '',
																		email: 'foo@fal.com',
																		password: '11111',
																		password_confirmation: '111111'}
		assert_template 'users/edit'
	end

	test "successful edit" do
		log_in_as(@user)
		get edit_user_path(@user)
		name = 'gwf22'
		email = 'sss@as.com'
		patch user_path(@user), user: { name: name,
																		email: email,
																		password: '',
																		password_confirmation: ''}
		assert_not flash.empty?
		assert_redirected_to @user
		@user.reload
    assert_equal @user.name,  name
    assert_equal @user.email, email
	end

	test "successful edit with friendly forwarding" do
		get edit_user_path(@user)
		assert_equal session[:forwarding_url], request.url
		log_in_as(@user)
		assert_nil session[:forwarding_url]
		#assert_redirected_to @user
		#assert_redirected_to user_path(@user)
		#a_r_t 为啥一会儿xx_url, 一会儿xx_path
		#xx/xx见user_signup_test.rb => assert_template 'users/show'
		assert_redirected_to edit_user_path(@user)
		name = "cgwf2"
		email = "casd@qq.com"
		patch user_path(@user), user: { name: name,
																		email: email,
																		password: '123456',
																		password_confirmation: '123456'}
		assert_not flash.empty?
		assert_redirected_to @user
		@user.reload
		assert_equal @user.name, name
		assert_equal @user.email ,email
	end
end
