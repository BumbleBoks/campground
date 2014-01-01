class AddConstraintsToUpdate < ActiveRecord::Migration
  def change
    reversible do |dir|
      change_table :community_updates do |t|
        dir.up do
          t.change :content, :text, limit: 500
          t.change :content, :text, null: false 
          t.change :author_id, :integer, null: false
          t.change :trail_id, :integer, null: false
        end
        
        dir.down do
          t.change :content, :text
          t.change :author_id, :integer
          t.change :trail_id, :integer
        end
        
      end
    end
  end
end