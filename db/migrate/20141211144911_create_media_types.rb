class CreateMediaTypes < ActiveRecord::Migration
  def change
    create_table :media_types do |t|
      t.string :name, :limit => 50
      t.string :description

      t.timestamps
    end
  end
end
