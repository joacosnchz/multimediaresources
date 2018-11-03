class CreateMaterials < ActiveRecord::Migration
  def change
    create_table :materials do |t|
      t.references :user
      t.references :media_type
      t.string :title
      t.text :body

      t.timestamps
    end
    add_index :materials, :user_id
    add_index :materials, :media_type_id
  end
end
