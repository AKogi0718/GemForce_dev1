class CreateProductStoneParts < ActiveRecord::Migration[8.0]
  def change
    create_table :product_stone_parts do |t|
      t.references :product, null: false, foreign_key: true
      t.references :stone_part, null: false, foreign_key: true
      t.integer :sequence
      t.string :format
      t.string :size_info
      t.string :shape
      t.string :kind
      t.decimal :carat_per_piece, precision: 8, scale: 4
      t.decimal :carat, precision: 8, scale: 4
      t.integer :quantity
      t.decimal :unit_price, precision: 10, scale: 2
      t.decimal :wage, precision: 10, scale: 2
      t.string :supply_status
      t.text :note

      t.timestamps
    end
  end
end
