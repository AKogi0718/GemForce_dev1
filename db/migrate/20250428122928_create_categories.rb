# db/migrate/20250428122928_create_categories.rb を確認・修正
class CreateCategories < ActiveRecord::Migration[8.0]
  def change
    create_table :categories do |t|
      t.string :code
      t.string :name
      t.references :parent, null: true, foreign_key: { to_table: :categories } # self参照に変更
      t.boolean :active

      t.timestamps
    end
    add_index :categories, :code, unique: true
  end
end
