class CreateSuppliers < ActiveRecord::Migration[8.0]
  def change
    create_table :suppliers do |t|
      t.string :code
      t.string :name
      t.string :type
      t.string :tel
      t.text :address
      t.string :contact_person
      t.string :email
      t.boolean :active

      t.timestamps
    end
    add_index :suppliers, :code, unique: true
  end
end
