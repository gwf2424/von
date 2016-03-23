class SessionsController < ApplicationController

  def delete_count
    delete_store_counter
    redirect_to store_url 
  end

  def new
  end

  def create
  	@user = User.find_by(email: params[:session][:email].downcase)
  	if @user && @user.authenticate(params[:session][:password])
=begin  #2015.10.06 login without email activated
      if @user.activated?
        log_in @user
        #remember user
        params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
        #redirect_to @user # redirect_to user_path(@user)
        #重定向到存储的地址，或者默认地址
        redirect_back_or @user
      else
        message = "Account not activated. "
        message += "Check your email for the activation link."
        flash[:warning] = message
        redirect_to root_url
      end
=end
#=begin 2-15.10.06
    log_in @user
    params[:session][:remember_me] == '1' ? remember(@user) : forget(@user)
    redirect_back_or @user
#=end
    else
      flash.now[:danger] = 'Invalid email/password combination'
  		render 'new'
  	end
  end

  def destroy
  	log_out if logged_in?
    redirect_to root_url
  end
end
