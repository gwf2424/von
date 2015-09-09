class AddIndexToUsersEmail < ActiveRecord::Migration
  def change
  	# 调用rails中的add_index方法，为users中的email建立索引
  	add_index :users, :email, unique: true
  end
end
