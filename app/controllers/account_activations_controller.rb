class AccountActivationsController < ApplicationController

	#激活email验证令牌
	def edit
		user = User.find_by(email: params[:email])
		#debugger
		#Q: params[:id]的值非id，为何是activation_digest?
		#A: params[:id]中的id指的是url中的值，并非是user的id
		if user && !user.activated? && user.authenticated?(:activation, params[:id])
			user.activate
			log_in user
			flash[:success] = "Account activated!"
			redirect_to user
		else
			flash[:danger] = "Invalid activation link"
			redirect_to root_url
		end
	end
end
