class CreateClients < ActiveRecord::Migration[8.0]
  def change
    create_table :clients do |t|
      t.string :code
      t.string :name
      t.string :name_kana
      t.string :alternate_name
      t.string :postal_code
      t.text :address
      t.integer :billing_cutoff_day
      t.string :tel
      t.string :fax
      t.decimal :unpaid_balance
      t.decimal :current_balance
      t.string :contact_person
      t.string :email
      t.string :payment_terms
      t.decimal :credit_limit
      t.string :client_type
      t.boolean :status

      t.timestamps
    end
    add_index :clients, :code, unique: true
  end
end
