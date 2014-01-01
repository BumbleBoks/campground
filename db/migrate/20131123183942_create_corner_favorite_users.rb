class CreateCornerFavoriteUsers < ActiveRecord::Migration
  def change
    create_table :corner_favorite_users do |t|
      t.integer :fan_id, null: false
      t.integer :star_id, null: false

      t.timestamps
    end
    add_index :corner_favorite_users, :fan_id
    add_index :corner_favorite_users, :star_id
    add_index :corner_favorite_users, [:fan_id, :star_id], unique: true    
  end
end
