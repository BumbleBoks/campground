class CreateCommunityTrades < ActiveRecord::Migration
  def change
    create_table :community_trades do |t|
      t.integer :trader_id, null: false
      t.string :trade_type, null: false
      t.string :gear, null: false
      t.text :description, null: false, limit: 500
      t.integer :activity_id
      t.string :trade_location, null: false
      t.decimal :min_price, precision: 6, scale: 2
      t.decimal :max_price, precision: 6, scale: 2
      t.boolean :completed, default: false
      
      t.timestamps
    end
    
    add_index :community_trades, :trade_type
    add_index :community_trades, :gear
    add_index :community_trades, [:min_price, :max_price]
    add_index :community_trades, :completed
  end
end
