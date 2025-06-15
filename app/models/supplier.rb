class Supplier < ApplicationRecord
  has_many :productions_as_prototype_maker, class_name: 'Production', foreign_key: 'prototype_maker_id'
  has_many :productions_as_cast_supplier, class_name: 'Production', foreign_key: 'cast_supplier_id'
  has_many :productions_as_polish_supplier, class_name: 'Production', foreign_key: 'polish_supplier_id'
  has_many :productions_as_stone_setting_supplier, class_name: 'Production', foreign_key: 'stone_setting_supplier_id'
  has_many :productions_as_finishing_supplier, class_name: 'Production', foreign_key: 'finishing_supplier_id'

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
