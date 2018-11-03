class CreateMaterialMedia < ActiveRecord::Migration
  def change
    create_table :material_media do |t|
      t.references :media
      t.references :material

      t.timestamps
    end
    add_index :material_media, :media_id
    add_index :material_media, :material_id
  end
end
