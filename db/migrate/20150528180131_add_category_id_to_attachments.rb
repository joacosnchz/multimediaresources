class AddCategoryIdToAttachments < ActiveRecord::Migration
  def change
    add_column :attachments, :category_id, :integer
  end
end
