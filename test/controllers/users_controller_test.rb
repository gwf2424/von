require 'test_helper'

class UsersControllerTest < ActionController::TestCase
  
	def setup
		@user = users(:gwf2)
		@other_user = users(:gwf3)
	end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should redirect edit when not logged in" do
  	get :edit, id: @user		#􏳳􏲛@user  => 􏲙􏰔@user.id
  	assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
  	patch :update, id: @user, user: { name: @user.name,
  																	email: @user.email}
  	assert_redirected_to login_url
  end

=begin test "shouled redirect show when not logged in" do
  	get :show, id: @user
  	assert_redirected_to login_url
  end
=end

	test "should redirect edit when logged in as wrong user" do
		log_in_as(@other_user)
		get :edit, id: @user
		assert_redirected_to root_url
	end

	test "should redirect update when logged in as wrong user" do
		log_in_as(@other_user)
		patch :update, id: @user, user: { name: @user.name,
																			email: @user.email}
		assert_redirected_to root_url
	end

  test "should redirect index when not logged in" do
    get :index
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    log_in_as(@other_user)
    assert_no_difference 'User.count' do
      delete :destroy, id: @user
    end
    assert_redirected_to root_url
  end

  test "should not allow admin attribute to be edited via the web" do
    log_in_as(@other_user)
    assert_not @other_user.admin?
    patch :update, id: @other_user, user: { name: "test",
                                            admin: true}                    
    assert_not @other_user.reload.admin
  end

  test "s redirect following when not log in" do
    get :following, id: @user
    assert_redirected_to login_url
  end

  test "s redirect followers when not log in" do
    get :following, id: @user.id #@user?
    assert_redirected_to login_url
  end

end
