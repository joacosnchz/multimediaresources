class CreateProfiles < ActiveRecord::Migration
  def change
    create_table :profiles do |t|
      t.references :user
      t.references :city
      t.string :first_name, :limit => 30
      t.string :last_name, :limit => 30
      t.string :address, :limit => 100
      t.string :zip, :limit => 10
      t.date :birth_date
      t.string :phone, :limit => 20
      t.string :mobile, :limit => 20
      t.string :gender, :limit => 1

      t.timestamps
    end
    add_index :profiles, :user_id
    add_index :profiles, :city_id
  end
end
