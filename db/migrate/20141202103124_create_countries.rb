class CreateCountries < ActiveRecord::Migration
  def change
    create_table :countries do |t|
      t.string :name, :limit => 30
      t.string :phone_code, :limit => 5

      t.timestamps
    end
  end
end
