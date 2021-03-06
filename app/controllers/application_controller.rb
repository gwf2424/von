class ApplicationController < ActionController::Base
  include CurrentCart
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_date_loaded
  before_action :set_cart

  include SessionsHelper

  private
		# 确保用户已登陆
		def logged_in_user
			unless logged_in?
				store_location
				flash[:danger] = "Please log in."
				redirect_to login_url
			end
		end

		def set_date_loaded
			@date_loaded = Time.now.strftime("%I:%M %p/%Y")
		end
end