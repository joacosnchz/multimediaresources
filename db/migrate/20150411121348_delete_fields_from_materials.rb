class DeleteFieldsFromMaterials < ActiveRecord::Migration
  def up
    remove_column :materials, :user_id
    remove_column :materials, :media_type_id
  end

  def down
  end
end
