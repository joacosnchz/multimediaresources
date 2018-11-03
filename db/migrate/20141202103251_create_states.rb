class CreateStates < ActiveRecord::Migration
  def change
    create_table :states do |t|
      t.references :country
      t.string :name, :limit => 30

      t.timestamps
    end
    add_index :states, :country_id
  end
end
