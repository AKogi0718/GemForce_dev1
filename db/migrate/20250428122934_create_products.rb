# db/migrate/20250428122934_create_products.rb を開いて修正
class CreateProducts < ActiveRecord::Migration[8.0]
  def change
    create_table :products do |t|
      t.string :code
      t.string :name
      t.references :client, null: true, foreign_key: true # null: true に変更
      t.string :client_code
      t.references :person, null: true, foreign_key: { to_table: :users } # users テーブルを参照するように変更
      t.text :casting_note
      t.text :polish_note
      t.references :category, null: true, foreign_key: true # null: true に変更
      t.string :project_name
      t.string :engraved
      t.text :note1
      t.text :note2
      t.decimal :price, precision: 10, scale: 2
      t.boolean :active, default: true # default: true を追加

      t.timestamps
    end
    add_index :products, :code, unique: true
  end
end
