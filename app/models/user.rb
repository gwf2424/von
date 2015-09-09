class User < ActiveRecord::Base

	has_secure_password

	# before_save { self.email = email.downcase}
	before_save { email.downcase!}

	VALID_EMAIL_REGE = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z\d\-]+)*\.[a-z]+\z/i

	validates :name, presence: true,
		length: { maximum: 10}

	validates :email, presence: true,
		length: { maximum: 20},
		format: { with: VALID_EMAIL_REGE},
		uniqueness: { case_sensitive: false}

	validates :password, length: { minimum: 6}
end