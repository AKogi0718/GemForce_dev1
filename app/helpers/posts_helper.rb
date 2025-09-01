# app/helpers/posts_helper.rb

module PostsHelper
  # データベース上で金額合計 (単価 * 数量) を計算するヘルパー
  def calculate_total_amount(posts_relation)
    # 【修正点】PostgreSQL対応: 文字列型のカラムを安全に数値計算する
    #
    # 1. NULLIF(column, ''): 空文字('')をNULLに変換する (PostgreSQLでは空文字を数値にCASTできないため)。
    # 2. CAST(... AS NUMERIC): 数値型に変換する。
    # 3. COALESCE(..., 0): NULL（元のNULLおよび空文字から変換されたNULL）を0に置き換える。

    sql = <<~SQL
      SUM(
        COALESCE(CAST(NULLIF(dashine, '') AS NUMERIC), 0) *
        COALESCE(CAST(NULLIF(lastamount, '') AS NUMERIC), 0)
      )
    SQL

    # Arel.sql() を使用して、安全に生のSQLスニペットをクエリに組み込みます。
    # 結果を整数にして返します (.to_i)
    posts_relation.sum(Arel.sql(sql)).to_i
  end

  # 請求書のサマリーを計算する
  def calculate_invoice_summary(past, pastallnyukin, pastallsousai, ageuri, minus, comp)
    # 1. 前回繰越残高の計算 (売上 - 入金 - 相殺)

    # 過去の売上合計
    past_sales_total = calculate_total_amount(past)
    # 過去の入金合計
    past_payments_total = calculate_total_amount(pastallnyukin)
    # 過去の相殺合計 (相殺は数量がマイナスの場合があるため、合計の絶対値を取得)
    past_offsets_total = calculate_total_amount(pastallsousai).abs

    previous_balance = past_sales_total - past_payments_total - past_offsets_total

    # 2. 当月売上
    current_sales_total = calculate_total_amount(ageuri)

    # 3. 当月相殺額 (絶対値)
    current_offsets_total = calculate_total_amount(minus).abs

    # 4. 消費税計算
    # ProsperCorporation モデルの tax カラムも文字列型の可能性があるため、.to_f で安全に変換する。
    # 税率が未設定の場合はデフォルト10%とする。
    tax_rate_percent = comp.try(:tax).to_f > 0 ? comp.tax.to_f : 10.0
    tax_rate = tax_rate_percent / 100.0

    # 課税対象額 (当月売上 - 当月相殺)
    taxable_amount = current_sales_total - current_offsets_total
    # 消費税計算 (切り捨て)
    current_tax = (taxable_amount * tax_rate).floor

    # 5. 請求合計
    # (前回繰越 + 課税対象額 + 消費税)
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
