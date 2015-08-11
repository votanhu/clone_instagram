class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.integer :id_photo
      t.integer :id_user
      t.string :message
      t.integer :is_notified, :default => 0

      t.timestamps
    end
  end
end
