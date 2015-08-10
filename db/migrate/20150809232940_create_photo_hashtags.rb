class CreatePhotoHashtags < ActiveRecord::Migration
  def change
    create_table :photo_hashtags do |t|
      t.integer :id_photo
      t.integer :id_tag

      t.timestamps
    end
  end
end
