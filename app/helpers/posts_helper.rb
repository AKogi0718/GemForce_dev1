# app/helpers/posts_helper.rb

module PostsHelper
  # データベース上で金額合計 (単価 * 数量) を計算するヘルパー
  # SQL: SUM(COALESCE(dashine, 0) * COALESCE(lastamount, 0))
  def calculate_total_amount(posts_relation)
    posts_relation.sum('COALESCE(dashine, 0) * COALESCE(lastamount, 0)').to_i
  end

  # 請求書のサマリーを計算する
  def calculate_invoice_summary(past, pastallnyukin, pastallsousai, ageuri, minus, comp)
    # 1. 前回繰越残高の計算 (売上 - 入金 - 相殺)

    # 過去の売上合計
    past_sales_total = calculate_total_amount(past)
    # 過去の入金合計 (入金は数量が1)
    past_payments_total = calculate_total_amount(pastallnyukin)
    # 過去の相殺合計 (相殺は数量がマイナスなので、合計の絶対値を取得)
    past_offsets_total = calculate_total_amount(pastallsousai).abs

    previous_balance = past_sales_total - past_payments_total - past_offsets_total

    # 2. 当月売上
    current_sales_total = calculate_total_amount(ageuri)

    # 3. 当月相殺額 (絶対値)
    current_offsets_total = calculate_total_amount(minus).abs

    # 4. 消費税計算
    # Corporationモデルにtaxカラム(税率%)が存在すると仮定。なければ10%とする。
    tax_rate_percent = comp.try(:tax).to_f > 0 ? comp.tax.to_f : 10.0
    tax_rate = tax_rate_percent / 100.0

    # 課税対象額 (当月売上 - 当月相殺)
    taxable_amount = current_sales_total - current_offsets_total
    current_tax = (taxable_amount * tax_rate).floor

    # 5. 請求合計
    # (前回繰越 + 課税対象額 + 消費税)
    # ※注意: 既存ロジックでは当月の入金は請求合計計算に含まれていません。
    total_billing = previous_balance + taxable_amount + current_tax

    {
      previous_balance: previous_balance,
      current_sales: current_sales_total,
      current_offsets: current_offsets_total,
      current_tax: current_tax,
      tax_rate_percent: tax_rate_percent.to_i,
      total_billing: total_billing
    }
  end
end
