class ProductImage < ApplicationRecord
  belongs_to :product
  has_one_attached :image
  validates :sequence, uniqueness: { scope: :product_id }
end
