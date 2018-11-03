class CreateMedia < ActiveRecord::Migration
  def change
    create_table :media do |t|
      t.string :nombre, :limit => 50
      t.string :description

      t.timestamps
    end
  end
end
