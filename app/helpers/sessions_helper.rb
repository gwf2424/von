module SessionsHelper

	def log_in(user)
		# 会自动加密user_id
		session[:user_id] = user.id
	end

	def log_out
		forget(current_user)
		session.delete(:user_id)
		@current_user = nil
	end

	# 返回 cookies中记忆令牌对应signed的用户
	# if (user_id = session[:user_id]) 这里是赋值,非比较
	def current_user
		if (user_id = session[:user_id])
			@current_user ||= User.find_by(id: user_id)
		elsif (user_id = cookies.signed[:user_id])
			# 打开浏览器，用户未登录，程序准备从cookies中自动登录
			#raise
			user = User.find_by(id: user_id)
			if(user && user.authenticated?(:remember, cookies[:remember_token]))
				log_in user
				@current_user = user
			end
		end
	end

	def logged_in?
		!current_user.nil?
	end

	#add remember_token & user_id in cookies
	def remember(user)
		#user.remember在数据库中添加密文remember_token
		user.remember
		cookies.permanent.signed[:user_id] = user.id
		cookies.permanent[:remember_token] = user.remember_token
	end

	def forget(user)
		user.forget
		cookies.delete(:user_id)
		cookies.delete(:remember_token)
	end

	def current_user?(user)
		user == current_user
	end

	#重定向到存储的地址，或者默认地址
	def redirect_back_or(default)
		redirect_to(session[:forwarding_url] || default)
		session.delete(:forwarding_url)
	end

	#存储以后需要获取的地址
	#后面的IF方法是为了筛选出get请求
	#用于 用户进入edit页面之后的重定向
	def store_location
		session[:forwarding_url] = request.url if request.get?
	end
end
