class CreateStoneParts < ActiveRecord::Migration[8.0]
  def change
    create_table :stone_parts do |t|
      t.string :code
      t.string :name
      t.string :stone_type
      t.string :format_type
      t.decimal :size
      t.decimal :specific_gravity
      t.string :color
      t.string :clarity
      t.decimal :market_price
      t.boolean :active

      t.timestamps
    end
    add_index :stone_parts, :code, unique: true
  end
end
