class CreateAttachments < ActiveRecord::Migration
  def change
    create_table :attachments do |t|
      t.references :material
      t.string :name

      t.timestamps
    end
    add_index :attachments, :material_id
  end
end
