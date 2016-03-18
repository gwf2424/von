class CreateLineItems < ActiveRecord::Migration
  def change
  	#drop_table :line_items
    create_table :line_items do |t|
      t.references :product, index: true, foreign_key: true
      t.belongs_to :cart, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
