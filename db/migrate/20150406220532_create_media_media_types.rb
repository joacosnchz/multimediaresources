class CreateMediaMediaTypes < ActiveRecord::Migration
  def change
    create_table :media_media_types do |t|
      t.references :media
      t.references :media_type

      t.timestamps
    end
    add_index :media_media_types, :media_id
    add_index :media_media_types, :media_type_id
  end
end
