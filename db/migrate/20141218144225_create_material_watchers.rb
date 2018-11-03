class CreateMaterialWatchers < ActiveRecord::Migration
  def change
    create_table :material_watchers do |t|
      t.references :user
      t.references :material
      t.integer :created_by_user_id

      t.timestamps
    end
    add_index :material_watchers, :user_id
    add_index :material_watchers, :material_id
  end
end
