class UsersController < ApplicationController
  before_action :logged_in_user, only: [:index, :edit, :update, :destroy]#, :show] 20151230 不登陆也可以查看该用户微博
  before_action :correct_user, only: [:edit, :update]#, :show] 20151230 若存在 当前用户访问好友跳转至主页
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
    @microposts = @user.microposts.paginate(page: params[:page])
  	#debugger
  end
  def create
  	@user = User.new(user_params)
  	if @user.save
      ##log_in @user #20151001 增加邮件验证之后应该注释掉  201512
      # applicationController 已经 include sessionshHelper
      @user.sent_activation_email #20151005 20160104
  		flash[:info] = "Please check your email to activate your account." #20151005 20160104
  		##flash[:info] = "Welcome! Click home to send your microposts!" #20151005 201512
      ##redirect_to @user #20151005 201512
      redirect_to root_url #20151005 20160104
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

    # 确保用户已登陆,迁移至application controller公用
=begin
def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please log in."
        redirect_to login_url
      end
    end
=end

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
