# db/migrate/20250428123606_create_productions.rb を開いて修正
class CreateProductions < ActiveRecord::Migration[8.0]
  def change
    create_table :productions do |t|
      t.references :product, null: false, foreign_key: true
      t.decimal :prototype_weight, precision: 8, scale: 3
      t.decimal :prototype_price, precision: 10, scale: 2
      t.decimal :prototype_cost, precision: 10, scale: 2
      t.date :prototype_date
      t.string :prototype_size
      t.references :prototype_maker, null: true, foreign_key: { to_table: :suppliers }
      t.references :cast_supplier, null: true, foreign_key: { to_table: :suppliers }
      t.references :polish_supplier, null: true, foreign_key: { to_table: :suppliers }
      t.references :stone_setting_supplier, null: true, foreign_key: { to_table: :suppliers }
      t.references :finishing_supplier, null: true, foreign_key: { to_table: :suppliers }
      t.decimal :cast_wage, precision: 10, scale: 2
      t.decimal :polish_wage, precision: 10, scale: 2
      t.decimal :stone_setting_wage, precision: 10, scale: 2
      t.decimal :finishing_wage, precision: 10, scale: 2

      t.timestamps
    end
  end
end
