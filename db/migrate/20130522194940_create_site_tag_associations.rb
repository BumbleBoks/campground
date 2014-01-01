class CreateSiteTagAssociations < ActiveRecord::Migration
  def change
    create_table :site_tag_associations do |t|
      t.integer :tag_id, null: false
      t.integer :taggable_id, null: false
      t.string :taggable_type, null: false

      t.timestamps
    end
    add_index :site_tag_associations, :tag_id
    add_index :site_tag_associations, [:taggable_id, :taggable_type], name: 'by_taggable_item'
    add_index :site_tag_associations, [:tag_id, :taggable_id, :taggable_type], 
      unique: true, name: 'by_tag_in_taggable_item'
  end
end
