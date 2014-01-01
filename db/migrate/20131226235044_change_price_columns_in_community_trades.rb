class ChangePriceColumnsInCommunityTrades < ActiveRecord::Migration
  def up
    add_column :community_trades, :price, :decimal, precision: 6, scale: 2, default: 0.00
    remove_column :community_trades, :min_price
    remove_column :community_trades, :max_price
    # remove_index :community_trades, column: [:min_price, :max_price]
    # remove_index :community_trades, name: "index_community_trades_on_min_price_and_max_price"
    add_index :community_trades, :price
    execute <<-SQL
     DROP INDEX IF EXISTS index_community_trades_on_min_price_and_max_price
    SQL
  end
  
  def down
    remove_column :community_trades, :price
    add_column :community_trades, :min_price, :decimal, precision: 6, scale: 2
    add_column :community_trades, :max_price, :decimal, precision: 6, scale: 2
    add_index :community_trades, [:min_price, :max_price]
    # remove_index :community_trades, column: :price    
    execute <<-SQL
     DROP INDEX IF EXISTS index_community_trades_on_price
    SQL
  end
end
