class ProductStonePart < ApplicationRecord
  belongs_to :product
  belongs_to :stone_part

  validates :sequence, uniqueness: { scope: :product_id }

  # 石パーツの表示名を計算するメソッド（旧システムのビューロジックをモデルに移行）
  def display_name
    case format
    when "石(〇〇×〇〇)"
      if size_info.length == 6
        "#{size_info[0,2]}.#{size_info[2,1]}mm×#{size_info[3,2]}.#{size_info[5,1]}mm"
      else
        "#{size_info[0,2]}mm×#{size_info[2,2]}mm"
      end
    when "バーツ(〇〇〇mm)"
      "#{size_info}mm"
    when "1/〇〇〇形式"
      "1/#{size_info}"
    else
      ""
    end
  end

  # 石パーツのコスト計算メソッド（旧システムのビューロジックをモデルに移行）
  def calculate_cost
    case format
    when "石(〇〇×〇〇)", "バーツ(〇〇〇mm)", "特殊項目"
      quantity * unit_price + quantity * wage
    when "1/〇〇〇形式"
      (quantity * unit_price / size_info.to_i) + (quantity * wage)
    else
      quantity * unit_price + quantity * wage
    end
  end
end
