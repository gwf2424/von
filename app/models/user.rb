class User < ActiveRecord::Base
	attr_accessor :remember_token,
								:activation_token,
								:reset_token

	has_secure_password
	has_many :microposts, dependent: :destroy

	#我关注的人 通过follower_id获取数组@user.following或者@user.followeds
	has_many :active_relationships, class_name: "Relationship",
																	foreign_key: "follower_id",
																	dependent: :destroy

	has_many :following, through: :active_relationships, source: :followed
	#通过through 获得relationship表中的followed_id集合,并使用source指定following数组由followed_id组成

	#关注我的人 followed_id是获取数组的关键
	has_many :passive_relationships, class_name: "Relationship",
																	 foreign_key: "followed_id",
																	 dependent: :destroy

	has_many :followers, through: :passive_relationships, source: :follower
	#has_many :followers, through: :passive_relationships可省略source rails会自动followers转follower 搜索follower_id

	#before_save { self.email = email.downcase}
	#before_save { email.downcase!}
	before_save :downcase_email
	before_create :create_activation_digest

	VALID_EMAIL_REGE = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :name, presence: true,
		length: { maximum: 50}

	validates :email, presence: true,
		length: { maximum: 50},
		format: { with: VALID_EMAIL_REGE},
		uniqueness: { case_sensitive: false}

	validates :password, length: { minimum: 6}, allow_blank: true

	#20160104
  def feed
    #microposts
    #Micropost.where("user_id in (?) OR user_id = ?", following_ids, id)
    #20160127
    #following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id ORDER BY followed_id DESC"	#获取被关注人的ids
    following_ids = "SELECT followed_id FROM relationships WHERE follower_id = :user_id"	#获取被关注人的ids
    Micropost.where("user_id IN (#{following_ids}) OR user_id = :user_id", user_id: id)
  end

	# 在数据库中插入加密后的remember_token
	def remember
		self.remember_token = User.new_token
		update_attribute(:remember_digest, User.digest(remember_token))
	end

	# 忘记用户cookies 即撤销user.remember
	def forget
		update_attribute(:remember_digest, nil)
	end

	# 获取加密密文
	def User.digest(string)
		cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST :
                                                      BCrypt::Engine.cost
		BCrypt::Password.create(string, cost: cost)
	end

	# 返回一个随机令牌
	def User.new_token
		SecureRandom.urlsafe_base64
	end

	# 令牌与摘要匹配
	def authenticated?(attribute, token)
		#debugger
		digest = self.send("#{attribute}_digest")
		return false if digest.nil?
		BCrypt::Password.new(digest).is_password?(token)
	end

	#激活用户更新数据库
	def activate
		update_attribute(:activated, true)
		update_attribute(:activated_at, Time.zone.now)
		#self.update_attribute(:actived, true)
		#self.update_attribute(:activation_at, Time.zone.now)
	end

	#在user控制器中调用，调用方法，实例变量@user.xxx
	def sent_activation_email
		UserMailer.account_activation(self).deliver_now
		#UserMailer.account_activation(@user).deliver_now
	end

	#设置密码重置的令牌
	def create_reset_digest
		self.reset_token = User.new_token
		update_attribute(:reset_digest, User.digest(reset_token))
		update_attribute(:reset_sent_at, Time.zone.now)
	end

	#发送邮件
	def send_password_reset_email
		UserMailer.password_reset(self).deliver_now
	end

	#验证密码重设是否超时
	def password_reset_expired?
		reset_sent_at < 2.hours.ago		
	end

	#20160125
	def follow(other_user)
		active_relationships.create(followed_id: other_user.id)
	end

	def unfollow(other_user)
		active_relationships.find_by(followed_id: other_user.id).destroy
	end

	def following?(other_user)
		following.include?(other_user)
	end

	private

		def downcase_email
			self.email = email.downcase
		end

		#创建 并赋值激活 令牌和摘要
		def create_activation_digest
			self.activation_token = User.new_token
			self.activation_digest = User.digest(activation_token)
		end

end