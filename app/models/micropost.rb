class Micropost < ActiveRecord::Base
  belongs_to :user
  default_scope -> { order(created_at: :desc)}
  mount_uploader :picture, PictureUploader#绑定图片
  validates :user_id, presence: true
  validates :content, presence: true, length: { maximum: 140 }

  #自定义
  validate :picture_size



  private
  	def picture_size
  		if picture.size > 2.megabytes
  			errors.add(:picture, "should be less than 2MB")
  		end  		
  	end
end
