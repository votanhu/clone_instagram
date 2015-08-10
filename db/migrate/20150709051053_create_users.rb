class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string  :username
      t.string  :password
      t.string  :name
      t.string  :phone
      t.string  :website
      t.string  :email
      t.integer :sex
      t.string  :bio
      t.integer :similiar_account_suggestion

      t.timestamps
    end
  end
end
