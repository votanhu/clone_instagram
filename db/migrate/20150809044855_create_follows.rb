class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :id_user
      t.integer :id_follower

      t.timestamps
    end
  end
end
