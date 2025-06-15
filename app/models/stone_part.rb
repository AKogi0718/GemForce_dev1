class StonePart < ApplicationRecord
  has_many :product_stone_parts
  has_many :products, through: :product_stone_parts

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  # 形式タイプの定義
  FORMAT_TYPES = [
    "1/〇〇〇形式",
    "石(〇〇×〇〇)",
    "バーツ(〇〇〇mm)",
    "特殊項目"
  ]

  validates :format_type, inclusion: { in: FORMAT_TYPES }
  def self.to_csv
    require 'csv'

    attributes = %w{id code name stone_type format_type size specific_gravity color clarity market_price active created_at updated_at}

    CSV.generate(headers: true) do |csv|
      csv << attributes

      all.each do |stone_part|
        csv << attributes.map{ |attr| stone_part.send(attr) }
      end
    end
    end
end
