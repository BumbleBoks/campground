class CreateCommonActivities < ActiveRecord::Migration
  def change
    create_table :common_activities do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :common_activities, :name, unique: true
  end
end
