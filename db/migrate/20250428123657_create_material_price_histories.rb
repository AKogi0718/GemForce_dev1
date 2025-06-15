# db/migrate/20250428123657_create_material_price_histories.rb を開いて修正
class CreateMaterialPriceHistories < ActiveRecord::Migration[8.0]
  def change
    create_table :material_price_histories do |t|
      t.references :material, null: false, foreign_key: true
      t.decimal :price, precision: 10, scale: 2
      t.datetime :effective_from
      t.datetime :effective_to
      t.references :recorded_by, null: true, foreign_key: { to_table: :users } # users テーブルを参照するように変更

      t.timestamps
    end
  end
end
