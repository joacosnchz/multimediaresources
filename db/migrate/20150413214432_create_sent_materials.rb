class CreateSentMaterials < ActiveRecord::Migration
  def change
    create_table :sent_materials do |t|
      t.references :user
      t.references :material

      t.timestamps
    end
    add_index :sent_materials, :user_id
    add_index :sent_materials, :material_id
  end
end
