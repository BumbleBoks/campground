class CreateCommunityUpdates < ActiveRecord::Migration
  def change
    create_table :community_updates do |t|
      t.text :content
      t.integer :author_id
      t.integer :trail_id

      t.timestamps
    end
  end
end
