class CreateCities < ActiveRecord::Migration
  def change
    create_table :cities do |t|
      t.references :state
      t.string :name, :limit => 30
      t.string :phone_area_code, :limit => 10

      t.timestamps
    end
    add_index :cities, :state_id
  end
end
