class CreateMaterialMediaTypes < ActiveRecord::Migration
  def change
    create_table :material_media_types do |t|
      t.references :material
      t.references :media_type

      t.timestamps
    end
    add_index :material_media_types, :material_id
    add_index :material_media_types, :media_type_id
  end
end
