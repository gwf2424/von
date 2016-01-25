require 'test_helper'

class RelationshipTest < ActiveSupport::TestCase
	def setup
		@relationship = Relationship.new(follower_id: 1, followed_id: 2)
	end

	test "s require follower_id" do
		@relationship.follower_id = nil
		assert_not @relationship.valid?
	end

	test "s require followed_id" do
		@relationship.followed_id = nil
		assert_not @relationship.valid?
	end

=begin
	test "s b valid" do
		assert @relationship.valid?
	end
=end
end