class Relationship < ActiveRecord::Base
	belongs_to :follower, class_name: "User"	#关注
	belongs_to :followed, class_name: "User"	#粉丝
	validates :follower, presence: true
	validates :followed, presence: true
end
