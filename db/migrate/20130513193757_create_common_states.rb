class CreateCommonStates < ActiveRecord::Migration
  def change
    create_table :common_states do |t|
      t.string :name, null: false

      t.timestamps
    end
    add_index :common_states, :name, unique: true
  end
end
