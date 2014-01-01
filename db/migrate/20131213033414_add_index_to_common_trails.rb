class AddIndexToCommonTrails < ActiveRecord::Migration
  def change
    add_index :common_trails, [:name, :state_id], unique: true
  end
end
