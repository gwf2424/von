require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
  	ActionMailer::Base.deliveries.clear
  	@user = users(:gwf2)
  end

  test "password resets" do
  	get new_password_reset_path
  	assert_template 'password_resets/new'
  	#1.email无效
  	post password_resets_path, password_reset: { email: ''}
    assert_equal "Email address not found", flash[:danger]
  	assert_template 'password_resets/new'

  	#2.email有效
  	post password_resets_path, password_reset: { email: @user.email}
  	#post之后，会插入reset_digest
  	assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_equal "Email sent with password reset instructions", flash[:info]
  	assert_redirected_to root_url

    #3.email错误，这里的电子邮件是拼接在url中的，并且会与db中的email做匹配，验证正确与否
    user = assigns(:user)
    get edit_password_reset_path(user.reset_token, email: '')
    assert_equal "Email sent with password reset instructions", flash[:info]
    assert_redirected_to root_url

    #4.用户未激活，此处强行将已授权取消
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_equal "Email sent with password reset instructions", flash[:info]
    assert_redirected_to root_url
    #follow_redirect!
    #assert_template 'static_pages/home' follow使用需注意
    user.toggle!(:activated)

    #5.用户地址正确，令牌不对
    get edit_password_reset_path('wrong token', email: '')
    assert_equal "Email sent with password reset instructions", flash[:info]
    assert_redirected_to root_url

    #6.用户地址正确，令牌正确
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_equal "Email sent with password reset instructions", flash[:info]
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    #7.密码和确认不一致，该功能在user.rb中由has_secure_password完成
    patch password_reset_path(user.reset_token), email: user.email,
                                                 user: { password: 'hahaha',
                                                         password_confirmation: 'heiheihei'}
    assert_select 'div#error_explanation'
    assert flash.empty?
    assert_template 'password_resets/edit'

    #8.密码和确认都为空
    patch password_reset_path(user.reset_token), email: user.email,
                                                 user: { password: '',
                                                         password_confirmation: ''}
    assert_select 'div', class: 'alert alert-danger'
    assert_not flash.empty?
    assert_template 'password_resets/edit'

    #9.密码和确认都有效
    #这条测试挺有意思，区别path和paths: assert_equal password_resets_path, password_reset_path
    patch password_reset_path(user.reset_token), email: user.email,
                                                 user: { password: '000000',
                                                         password_confirmation: '000000'}
    assert is_logged_in?
    assert_redirected_to user_path(user)
    assert_not flash.empty?

  end
end