class SettingsController < ApplicationController
	before_action :logged_in_user, only: [:edit, :update]#, :show] 20151230 不登陆也可以查看该用户微博
  before_action :admin_user, only: [:edit, :update]


	def update
		@setting = Setting.first
		if @setting.update_attributes(setting_params)
			flash[:success] = "Setting Modified"
			redirect_to edit_setting_path(@setting)
		else
			render 'edit'
		end
	end

	def edit
    @setting = Setting.first
	end

	private

		def setting_params()
			params.require(:setting).permit(:isUseMail, :isPicMicropost)
			
		end

		def admin_user
			redirect_to root_url unless current_user.admin?
		end
end
