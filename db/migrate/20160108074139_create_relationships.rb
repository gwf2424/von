class CreateRelationships < ActiveRecord::Migration
	def change
		create_table :relationships do |t|
			t.integer :follower_id	#关注
			t.integer :followed_id	#粉丝

			t.timestamps null: false
		end
		add_index :relationships, :follower_id
		add_index :relationships, :followed_id
		add_index :relationships, [:follower_id, :followed_id], unique: true
	end
end