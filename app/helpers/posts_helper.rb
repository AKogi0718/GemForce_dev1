# app/helpers/posts_helper.rb

module PostsHelper
  # データベース上で金額合計 (単価 * 数量) を計算するヘルパー
  def calculate_total_amount(posts_relation)
    # 【修正点】カラムのデータ型に応じてSQLを動的に生成する

    # リレーションからモデルクラス（例: ProsperPost）を取得
    return 0 unless posts_relation.respond_to?(:model)
    model = posts_relation.model

    # カラム名に応じて適切なSQLスニペットを生成する内部関数
    generate_sql_for = ->(column_name) {
      # ActiveRecordが認識しているカラムのデータ型を取得
      column_type = model.columns_hash[column_name]&.type
      # 数値型かどうかを判定
      is_numeric = [:integer, :float, :decimal, :numeric].include?(column_type)

      if is_numeric
        # すでに数値型の場合: NULLを0に置き換えるだけ (COALESCE)
        "COALESCE(#{column_name}, 0)"
      else
        # 文字列型の場合: 空文字をNULLにし(NULLIF)、数値(NUMERIC)に変換(CAST)してから0に置き換える
        # COALESCEの型不一致を防ぐため、リテラルは 0.0 を使用します。
        "COALESCE(CAST(NULLIF(#{column_name}, '') AS NUMERIC), 0.0)"
      end
    }

    # 単価と数量のSQLスニペットを生成
    dashine_sql = generate_sql_for.call('dashine')
    lastamount_sql = generate_sql_for.call('lastamount')

    # 最終的な計算式を組み合わせる
    # SUM((単価のSQL) * (数量のSQL))
    sql = "SUM((#{dashine_sql}) * (#{lastamount_sql}))"

    # SQLを実行し、結果を整数で返す (.to_i)
    # Arel.sql() を使用して、安全に生のSQLスニペットをクエリに組み込みます。
    posts_relation.sum(Arel.sql(sql)).to_i
  end

  # 請求書のサマリーを計算する
  # (calculate_invoice_summary メソッドは変更ありません)
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
    # ProsperCorporation モデルの tax カラムも考慮し、.to_f で安全に変換する。
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
