class AddEmailToMedia < ActiveRecord::Migration
  def change
    add_column :media, :email, :string
  end
end
