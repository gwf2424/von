class CreateSettings < ActiveRecord::Migration
  def change
    create_table :settings do |t|
      t.boolean :isPicMicropost
      t.boolean :isUseMail

      t.timestamps null: false
    end
  end
end
