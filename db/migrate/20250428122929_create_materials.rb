class CreateMaterials < ActiveRecord::Migration[8.0]
  def change
    create_table :materials do |t|
      t.string :code
      t.string :name
      t.decimal :market_price
      t.decimal :specific_gravity
      t.decimal :platinum_rate
      t.decimal :gold_rate
      t.decimal :palladium_rate
      t.decimal :silver_rate
      t.boolean :active

      t.timestamps
    end
    add_index :materials, :code, unique: true
  end
end
