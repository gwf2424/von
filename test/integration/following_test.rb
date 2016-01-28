require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:gwf2)
		@other = users(:gwf3)
		log_in_as(@user)
	end

	test "following page" do
		get following_user_path(@user)
		assert_not @user.following.empty?
		assert_match @user.following.count.to_s, response.body
		@user.following.each do |user|
			assert_select 'a[href=?]', user_path(user)
		end
	end

	test "followers page" do
		get followers_user_path(@user)
		assert_not @user.followers.empty?
		assert_match @user.followers.count.to_s, response.body
		@user.followers.each do |user|
			assert_select 'a[href=?]', user_path(user)			
		end
	end

	test "s follow a user the standard way" do
		assert_difference "@user.following.count", 1 do
			post relationships_path, followed_id: @other.id
		end
	end

	test "s follow a user with Ajax" do
		assert_difference "@user.following.count", 1 do
			xhr :post, relationships_path, followed_id: @other.id
		end
	end

	test "s unfollow a user the standard way" do
		@user.follow(@other)
		#找到关注与粉丝的主动关系
		relationship = @user.active_relationships.find_by(followed_id: @other.id)
		assert_difference "@other.followers.count", -1 do
			delete relationship_path(relationship)
		end
	end

	test "s unfollow a user with Ajax" do
		@user.follow(@other)
		relationship = @other.passive_relationships.find_by(follower_id: @user.id)
		assert_difference "@other.followers.count", -1 do
			xhr :delete, relationship_path(relationship)
		end
	end

	test "feed on Home Page" do
		get root_path
		@user.feed.paginate(page: 1).each do |micropost|
			assert_match CGI.escapeHTML(micropost.content), response.body
			#assert_equal micropost, "xxxxxxxxx"
		end
	end

end
