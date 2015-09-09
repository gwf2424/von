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
		@user.name = "a" * 11
		assert_not @user.valid?
	end

	test "email should not be too long" do
		@user.email = "e" * 21
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
end
