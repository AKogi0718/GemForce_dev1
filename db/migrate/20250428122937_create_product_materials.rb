class CreateProductMaterials < ActiveRecord::Migration[8.0]
  def change
    create_table :product_materials do |t|
      t.references :product, null: false, foreign_key: true
      t.references :material, null: false, foreign_key: true
      t.integer :sequence
      t.decimal :quantity, precision: 8, scale: 3
      t.decimal :casting_weight, precision: 8, scale: 3
      t.decimal :finishing_weight, precision: 8, scale: 3
      t.decimal :wage, precision: 10, scale: 2
      t.text :note

      t.timestamps
    end
  end
end
