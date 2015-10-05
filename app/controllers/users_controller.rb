class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :show, :destroy]
  before_action :correct_user, only: [:edit, :update, :show]
  before_action :admin_user, only: :destroy

  def index
    #@users = User.all
    #使用分业技术，方法参数由will_pagenate提供
    @users = User.paginate(page: params[:page])
  end

  def new
  	@user = User.new
  end
  def show
  	@user = User.find(params[:id])
  	# debugger
  end
  def create
  	@user = User.new(user_params)
  	if @user.save
      log_in @user #2015.10.05 增加邮件验证之后注释
      # applicationController 已经 include sessionshHelper
      #@user.sent_activation_email #2015.10.05
  		#flash[:info] = "Please check your email to activate your account." #2015.10.05
  		flash[:info] = "Welcome!" #2015.10.05
      redirect_to @user #2015.10.05
      #redirect_to root_url #2015.10.05
  	else
  		render 'new'
  	end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    #@user = User.find(params[:id]) #:correct_user代替
    if @user.update_attributes(user_params)
      flash[:success] = "Profile updated"
      redirect_to @user
    else
      render 'edit'
    end
  end

  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User deleted"
    redirect_to users_url
  end

  private

  	def user_params()
  		params.require(:user).permit(:name, :email, :password, :password_confirmation)
  	end

    # 确保用户已登陆
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end

    #确保是正确的用户
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless @user == current_user
    end

    #确保是管理员
    def admin_user
      redirect_to root_url unless current_user.admin?
    end
end
