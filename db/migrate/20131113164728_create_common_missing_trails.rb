class CreateCommonMissingTrails < ActiveRecord::Migration
  def change
    create_table :common_missing_trails do |t|
      t.string :user_name, null: false
      t.string :user_email, null: false
      t.string :info, null: false, limit: 1000
      t.string :updates, limit: 5000

      t.timestamps
    end
    
    add_index :common_missing_trails, :created_at 
  end
end
