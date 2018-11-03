class RemoveEmailFromMedia < ActiveRecord::Migration
  def up
    remove_column :media, :email
  end

  def down
  end
end
