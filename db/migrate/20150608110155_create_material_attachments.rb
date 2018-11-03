class CreateMaterialAttachments < ActiveRecord::Migration
  def change
    create_table :material_attachments do |t|
      t.references :material
      t.references :attachment

      t.timestamps
    end
    add_index :material_attachments, :material_id
    add_index :material_attachments, :attachment_id
  end
end
