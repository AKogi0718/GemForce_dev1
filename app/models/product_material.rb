class ProductMaterial < ApplicationRecord
  belongs_to :product
  belongs_to :material

  validates :sequence, uniqueness: { scope: :product_id }
end
