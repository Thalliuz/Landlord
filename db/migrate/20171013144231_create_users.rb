class CreateUsers < ActiveRecord::Migration[5.1]
  def change
    create_table :users do |t|
      t.string :username
      t.string :firstname
      t.string :lastname
      t.string :address
      t.string :phonenumber
      t.string :password_digest
      t.references :owner
      t.timestamps
    end
  end
end
