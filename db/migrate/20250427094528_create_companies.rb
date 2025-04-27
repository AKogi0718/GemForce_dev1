class CreateCompanies < ActiveRecord::Migration[8.0]
  def change
    create_table :companies do |t|
      t.string :name
      t.string :company_id
      t.string :address
      t.string :phone
      t.string :email
      t.integer :max_users
      t.integer :admin_licenses
      t.integer :staff_licenses
      t.boolean :is_owner

      t.timestamps
    end
  end
end
