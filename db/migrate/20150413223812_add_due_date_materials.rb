class AddDueDateMaterials < ActiveRecord::Migration
  def up
    add_column :materials, :due_date, :date
  end

  def down
  end
end
