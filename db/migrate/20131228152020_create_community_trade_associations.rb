class CreateCommunityTradeAssociations < ActiveRecord::Migration
  def change
    create_table :community_trade_associations do |t|
      t.integer :trade_id, null: false
      t.integer :user_id, null: false
      t.string :association_type, null: false

      t.timestamps
    end
    
    add_index :community_trade_associations, :user_id
    add_index :community_trade_associations, :trade_id
    add_index :community_trade_associations, [:user_id, :trade_id], unique: true
  end
end
