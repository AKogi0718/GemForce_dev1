class CreateParts < ActiveRecord::Migration[8.0]
  def change
    create_table :parts do |t|
      t.string :code
      t.string :name
      t.string :shape
      t.string :material_type
      t.decimal :market_price
      t.boolean :active

      t.timestamps
    end
    add_index :parts, :code, unique: true
  end
end
