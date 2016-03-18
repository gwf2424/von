class CreateCarts < ActiveRecord::Migration
  def change
  	drop_table :carts
    create_table :carts do |t|

      t.timestamps null: false
    end
  end
end
