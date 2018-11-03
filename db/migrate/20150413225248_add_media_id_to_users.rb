class AddMediaIdToUsers < ActiveRecord::Migration
  def change
    add_column :users, :media_id, :integer
  end
end
