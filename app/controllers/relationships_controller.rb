class RelationshipsController < ApplicationController
	before_action :logged_in_user

	def create
		#post
		@user = User.find(params[:followed_id])
		current_user.follow(@user)
		#redirect_to user_path(@user)
		respond_to do |format|
			format.html	{ redirect_to @user}
			format.js#js文件在view的relationships目录下
		end
	end

	def destroy
		#delete
		@user = Relationship.find(params[:id]).followed
		current_user.unfollow(@user)
		#redirect_to @user		
		respond_to do |format|
			format.html	{ redirect_to @user}
			format.js
		end
	end
end
