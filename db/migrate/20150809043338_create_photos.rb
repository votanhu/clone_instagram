class CreatePhotos < ActiveRecord::Migration
  def change
    create_table :photos do |t|
      t.integer :id_user
      t.string :name
      t.string :url
      t.string :exif

      t.timestamps
    end
  end
end
