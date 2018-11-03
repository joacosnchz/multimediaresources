class RemoveMaterialIdFromAttachments < ActiveRecord::Migration
  def up
    remove_column :attachments, :material_id
  end

  def down
  end
end
