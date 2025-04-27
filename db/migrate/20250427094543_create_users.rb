class CreateUsers < ActiveRecord::Migration[8.0]
  def change
    create_table :users do |t|
      t.string :name
      t.string :email
      t.string :password
      t.references :company, null: false, foreign_key: true
      t.string :user_type

      t.timestamps
    end
  end
end
