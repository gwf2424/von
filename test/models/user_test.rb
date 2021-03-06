require 'test_helper'

class UserTest < ActiveSupport::TestCase

	def setup
		@user = User.new(
			name: "ggwwff",
			email: "gwf@sina.com",
			password: "foobar",
			password_confirmation: "foobar")
		# password两个为虚拟属性
	end

	test "should be valid" do
		assert @user.valid?
	end

	# assert_not means if user.name is wrong
	# then, return true
	test "name shoule not be too long" do
		@user.name = "a" * 51
		assert_not @user.valid?
	end

	#??????为什么测试不了超位数的email!!!
	test "email should not be too long" do
		@user.email = "a" * 21
		assert_not @user.valid?
	end

	test "email validation shoule reject invalid addresses" do
		invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                               foo@bar_baz.com foo@bar+baz.com foo@bar..com]
		invalid_addresses.each do |address|
			@user.email = address
			assert_not @user.valid?, "#{address.inspect} should be invalid"
		end
	end

	test "email addr should be unique" do
		duplicate_user = @user.dup
		duplicate_user.email = @user.email.upcase
		@user.save
		assert_not duplicate_user.valid?
	end

	test "email addr should be saved as lower-case" do
		mixed_mail = "Foo@ExamPLe.cOM"
		@user.email = mixed_mail
		@user.save
		assert_equal mixed_mail.downcase, @user.reload.email
	end

	test "should have a minimum length" do
		@user.password = @user.password_confirmation = "a" * 5
		assert_not @user.valid?
	end

	test "authenticated? should return false for a user with nil digest" do
		assert_not @user.authenticated?(:remember, '')
	end

	test "associated micropost sb delete"	do
		@user.save
		@user.microposts.create!(content: "well well well")
		assert_difference 'Micropost.count', -1 do
			@user.destroy
		end
	end

	test "s follow and unfollow a user" do
		gwf2 = users(:gwf2)
		gwf3 = users(:gwf3)
		assert_not gwf2.following?(gwf3)
		gwf2.follow(gwf3)
		assert gwf2.following?(gwf3)
		#assert gwf3.followers.include?(gwf2)
		gwf2.unfollow(gwf3)
		assert_not gwf2.following?(gwf3)
	end

	test "feed s have the right posts" do
		gwf2 = users(:gwf2)#gwf2->lana
		lana = users(:lana)#lana->gwf2
		archer = users(:archer)#archer->gwf2
		#gwf2关注lana
		lana.microposts.each{ |post_following| assert gwf2.feed.include?(post_following)}

		#gwf2自己
		gwf2.microposts.each{ |post_self| assert gwf2.feed.include?(post_self)}

		#gwf未关注archer
		archer.microposts.each{ |post_unfollowed| assert_not gwf2.feed.include?(post_unfollowed)}

	end
end
