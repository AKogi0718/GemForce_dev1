class Production < ApplicationRecord
  belongs_to :product
  belongs_to :prototype_maker, class_name: 'Supplier', optional: true
  belongs_to :cast_supplier, class_name: 'Supplier', optional: true
  belongs_to :polish_supplier, class_name: 'Supplier', optional: true
  belongs_to :stone_setting_supplier, class_name: 'Supplier', optional: true
  belongs_to :finishing_supplier, class_name: 'Supplier', optional: true
end
