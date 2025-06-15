class Material < ApplicationRecord
  has_many :product_materials
  has_many :products, through: :product_materials
  has_many :material_price_histories

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  def self.to_csv
  require 'csv'

  attributes = %w{id code name market_price specific_gravity platinum_rate gold_rate palladium_rate silver_rate active created_at updated_at}

  CSV.generate(headers: true) do |csv|
    csv << attributes

    all.each do |material|
      csv << attributes.map{ |attr| material.send(attr) }
    end
    end
  end

end
