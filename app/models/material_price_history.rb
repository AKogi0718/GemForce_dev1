class MaterialPriceHistory < ApplicationRecord
  belongs_to :material
  belongs_to :recorded_by, class_name: 'User'
end
