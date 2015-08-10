class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :id_photo
      t.string :message

      t.timestamps
    end
  end
end
