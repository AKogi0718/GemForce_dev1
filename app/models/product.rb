class Product < ApplicationRecord
  belongs_to :client
  belongs_to :person, optional: true
  belongs_to :category, optional: true

  has_one :production, dependent: :destroy
  has_many :product_materials, dependent: :destroy
  has_many :materials, through: :product_materials
  has_many :product_stone_parts, dependent: :destroy
  has_many :stone_parts, through: :product_stone_parts
  has_many :product_images, dependent: :destroy

  # これらの行が重要です
  accepts_nested_attributes_for :production, allow_destroy: true
  accepts_nested_attributes_for :product_materials, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :product_stone_parts, allow_destroy: true, reject_if: :all_blank
  accepts_nested_attributes_for :product_images, allow_destroy: true, reject_if: :all_blank
  

  validates :code, presence: true, uniqueness: true
  validates :name, presence: true

  def self.to_csv
  CSV.generate(headers: true) do |csv|
    csv << [
      'コード', '品名', '取引先', '相手品番', '価格', 'カテゴリ', '企画名',
      '備考1', '備考2', '備考3', '備考4'
    ]

    all.each do |product|
      csv << [
        product.code,
        product.name,
        product.client&.name,
        product.client_code,
        product.price,
        product.category&.name,
        product.project_name,
        product.casting_note,
        product.polish_note,
        product.note1,
        product.note2
      ]
    end
    end
  end
end
