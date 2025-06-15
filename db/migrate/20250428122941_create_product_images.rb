class CreateProductImages < ActiveRecord::Migration[8.0]
  def change
    create_table :product_images do |t|
      t.references :product, null: false, foreign_key: true
      t.integer :sequence
      t.string :filename
      t.string :content_type

      t.timestamps
    end
  end
end
