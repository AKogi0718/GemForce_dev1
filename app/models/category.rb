class Category < ApplicationRecord
  belongs_to :parent, class_name: 'Category', optional: true
  has_many :subcategories, class_name: 'Category', foreign_key: 'parent_id'
  has_many :products

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true
end
