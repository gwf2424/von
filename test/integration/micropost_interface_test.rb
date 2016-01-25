require 'test_helper'

class MicropostInterfaceTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:gwf2)
	end

	test "micropost interface test" do
		log_in_as(@user)
		get root_path
		assert_select 'div.pagination'	#element selector

		#无效提交
		assert_no_difference 'Micropost.count' do
			post microposts_path, micropost: { content: ""}
		end
		assert_select 'div#error_explanation'	#id selector

		#有效提交
		content = "this is the valid micropost hahahaha"
		assert_difference 'Micropost.count', 1 do
			post microposts_path, micropost: { content: content}
		end
		#assert_equal root_url, root_path #url = www.xxx.com path = /
		assert_redirected_to root_url
		follow_redirect!
		assert_match content, response.body

		#删除一篇微博
		assert_select 'a', text: 'delete'	#找到删除的控件
		first_micropost = @user.microposts.paginate(page: 1).first
		assert_difference 'Micropost.count', -1 do
			delete micropost_path(first_micropost)
		end

		#访问另一个用户页面
		get user_path(users(:archer))
		assert_select 'a', text: 'delete', count: 0
	end

	test "micropost sidebar count" do
		log_in_as(@user)
		get root_path
		assert_match "#{@user.microposts.count} microposts", response.body

		other_user = users(:gwf3)
		log_in_as(other_user)
		get root_path
		assert_match "0 microposts", response.body
		other_user.microposts.create!(content: "M")
		get root_path
		assert_match "1 micropost", response.body
	end

end
