# app/controllers/posts_controller.rb
class PostsController < ApplicationController
  def index
    render plain: "Hello from Posts#index"
  end

  def select
  end

  def monthselect
    year = params[:year]
    month = params[:month]
    redirect_to theaccounting_path(year: year, month: month)
  end
  def theaccounting
    @year = params[:year]
    @month = params[:month].to_s.rjust(2, '0')

    # 対象月と、既存システムの「2021-05-01」からの期間情報を算出
    begin
      target_month_start = Date.new(@year.to_i, @month.to_i, 1)
    rescue ArgumentError
      flash[:alert] = "年月の指定が不正です。"
      redirect_to action: :monthselect
      return
    end

    @search_date = target_month_start
    @search_date2 = target_month_start.prev_month
    @lastdate = @search_date2.end_of_month
    @first = Date.new(2021, 5, 1)
    past_range = @first...@search_date
    current_month_range = @search_date.beginning_of_month..@search_date.end_of_month

    # 外部DB（prosper）からのデータ取得
    # 外部DB（prosper）からのデータ取得（現行システムの条件を踏襲）
    @comp = ProsperCorporation.where.not(client: ["×", nil, "client", "マクドナルド"])
                               .order(gana: :asc)

    @posts = ProsperPost.where.not(nouhinnum: nil)
                        .where(lastdate: current_month_range)

    # 先月末までの全受注（入金・相殺を除外）
    @pastprice = ProsperPost.where.not(nouhinnum: nil).where.not(modelnumber: "入金").where.not("modelnumber LIKE ?", "%相殺%").where(lastdate: past_range)

    # 今月の売上（入金・相殺を除外、特定担当者を除外）
    @nowprice = ProsperPost.where.not(nouhinnum: nil).where(lastdate: current_month_range).where.not(modelnumber: "入金").where.not("modelnumber LIKE ?", "%相殺%").where.not(person: "荻原誠二")

    # 先月末までの全入金
    @pastallnyukin = ProsperPost.where.not(nouhinnum: nil).where(modelnumber: "入金").where(lastdate: past_range)

    # 今月の入金
    @nowallnyukin = ProsperPost.where.not(nouhinnum: nil).where(modelnumber: "入金").where(lastdate: current_month_range)

    # 先月末までの全相殺
    @pastallsousai = ProsperPost.where.not(nouhinnum: nil).where("modelnumber LIKE ?", "%相殺%").where(lastdate: past_range)

    # 今月の相殺
    @nowsousai = ProsperPost.where.not(nouhinnum: nil).where("modelnumber LIKE ?", "%相殺%").where(lastdate: current_month_range)

    @urikake1 = ProsperUrikake.where(date: @first...@search_date)
    @urikake2 = ProsperUrikake.where(date: @search_date.beginning_of_month..@search_date.end_of_month)


    render 'theaccounting'
  end

  # 請求一覧画面
  # 既存ロジック（現在日から約1ヶ月前の同日までの範囲）を踏襲しつつ、安全な日付計算に改善
  # 請求一覧画面
  def seikyu
    time_now = Time.zone.now
    year = time_now.year
    month = time_now.month
    day = time_now.day

    # ビュー表示用に年月を保持（既存コード互換）
    @year2 = year.to_s
    @month2 = time_now.strftime("%m")
    @day2 = day.to_s

    # 開始時刻（前月の同日）の計算
    if month == 1
      start_year = year - 1
      start_month = 12
    else
      start_year = year
      start_month = month - 1
    end

    # Time.zone.local を使用して開始日を生成します。
    # これにより、日付が存在しない場合（例：3/31に対する2/31）のロールオーバー動作（翌月になる）を再現し、
    # 既存の文字列操作による挙動を安全に模倣します。
    start_time = Time.zone.local(start_year, start_month, day).beginning_of_day
    # 終了時刻は当日の終わり
    end_time = time_now.end_of_day

    # ビュー表示用に期間を保持（既存コードの @timeb, @time に対応）
    @timeb = start_time.to_date
    @time = time_now.to_date

    @comp = ProsperCorporation.all
    # 納品済み(process: 6)で、納品番号があり、対象期間内のデータを取得
    posts_query = ProsperPost.where(process: 6)
                             .where.not(nouhinnum: nil)
                             .where(lastdate: start_time..end_time)

    @q = posts_query.ransack(params[:q])

    # 【修正点】 .order(created_at: :desc) を削除しました。
    # 会社一覧を取得する際 (ビューでpluck(:client)する際) に、
    # PostgreSQL環境で DISTINCT と ORDER BY が競合するエラー (PG::InvalidColumnReference) を防ぐためです。
    @posts = @q.result(distinct: true)

    # 会社一覧表示のために使用する変数 (ビューで使用)
    @postss = @posts

    # 既存コードからの移行
    @cast = ProsperPost.find_by(castprint: 0)
  end

  # 請求月選択後のリダイレクト処理
  def selecting
    client = params[:client]
    year = params[:year]
    month = params[:month]
    # Corporation.all は不要
    sime = ProsperCorporation.find_by(client: client)

    if sime
      # ルーティングヘルパーを使用
      redirect_to posts_invoice_path(client: client, year: year, month: month, date: sime.date)
    else
      flash[:alert] = "取引先情報が見つかりませんでした。"
      redirect_to action: :seikyu
    end
  end

  # 請求書発行画面
  def invoice
    @client_name = params[:client]

    @comp = ProsperCorporation.find_by(client: @client_name)

    unless @comp
      flash[:alert] = "指定された取引先が見つかりません。"
      redirect_to action: :seikyu
      return
    end

    # パラメータを数値で取得
    begin
      year = params[:year].to_i
      month = params[:month].to_i
      Date.new(year, month, 1) # バリデーション
    rescue
      flash[:alert] = "年月の指定が不正です。"
      redirect_to action: :seikyu
      return
    end

    # ビュー表示用に保持（既存コードの @yyy, @mmm に対応）
    @yyy = year.to_s
    @mmm = month.to_s.rjust(2, '0')

    # 基準開始日（既存コードの "2021-05-01" を踏襲）
    @base_start_date = Date.new(2021, 5, 1)

    # 会社の締め日に応じて処理を分岐
    if @comp.date == "00"
      # 月末締めの場合
      prepare_invoice_monthend(year, month)
    else
      # 特定日締めの場合
      prepare_invoice_specific_day(year, month, @comp.date.to_i)
    end

    # 共通で使われる変数（既存コードより移行）
    @uri = ProsperUrikake.where(client: @client_name)
    @ur = ProsperUrikake.find_by(client: @client_name)
    @cast = ProsperPost.find_by(castprint: 0)
  end

  # ... (既存の他のアクションは省略) ...

  private

  # 月末締め (date == "00") の場合の請求データ準備
  def prepare_invoice_monthend(year, month)
    target_month_start = Date.new(year, month, 1)

    # 請求書発行日（当月末）
    @issuedate = target_month_start.end_of_month

    # 過去データ範囲（当月開始前まで）
    past_range = @base_start_date...target_month_start
    # 当月データ範囲（当月全体）
    current_range = target_month_start.in_time_zone.all_month

    # 既存コード踏襲：月末締めは LIKE検索
    fetch_invoice_data(past_range, current_range, use_like_for_offset: true)
  end

  # 特定日締めの場合の請求データ準備
  def prepare_invoice_specific_day(year, month, closing_day)
    # 1. 当月の締め日（期間終了日）を計算
    # 日付が無効な場合（例：2月30日）は月末に調整
    if Date.valid_date?(year, month, closing_day)
      current_period_end = Date.new(year, month, closing_day)
    else
      current_period_end = Date.new(year, month, 1).end_of_month
    end
    @issuedate = current_period_end

    # 2. 前月の締め日を計算
    target_month_start = Date.new(year, month, 1)
    prev_month_start = target_month_start - 1.month

    if Date.valid_date?(prev_month_start.year, prev_month_start.month, closing_day)
      prev_period_end = Date.new(prev_month_start.year, prev_month_start.month, closing_day)
    else
      prev_period_end = prev_month_start.end_of_month
    end

    # 3. 当月の開始日を計算（前月の締め日翌日）
    current_period_start = prev_period_end + 1.day

    # 過去データ範囲（当月開始前まで）
    past_range = @base_start_date...current_period_start

    # 当月データ範囲（開始日から終了日まで）
    # 終了日の翌日の開始時刻までの範囲指定とする
    current_range = current_period_start.in_time_zone.beginning_of_day...(current_period_end + 1.day).in_time_zone.beginning_of_day

    # 既存コード踏襲：指定日締めは完全一致検索
    fetch_invoice_data(past_range, current_range, use_like_for_offset: false)
  end

  # 請求データ取得処理の共通化
  # 既存コードの複雑な条件分岐（modelnumberとmodelnameの混在、相殺条件の違い）を維持
  def fetch_invoice_data(past_range, current_range, use_like_for_offset: true)
    client = @comp.client

    # 過去データの相殺条件の設定
    if use_like_for_offset
      # 月末締めの場合: modelnumber LIKE
      past_offset_condition = ["modelnumber LIKE ?", "%相殺%"]
    else
      # 指定日締めの場合: modelnumber 完全一致
      past_offset_condition = { modelnumber: "相殺" }
    end

    # 当月データの売上・相殺条件の設定（既存コードのロジックを維持）
    if use_like_for_offset
      # 月末締めの場合: modelnameで入金を除外し、modelnumberのLIKEで相殺を除外
      current_sales_conditions = ProsperPost.where.not(modelname: "入金").where.not("modelnumber LIKE ?", "%相殺%")
      current_offset_condition = ["modelnumber LIKE ?", "%相殺%"]
    else
      # 指定日締めの場合: modelnameで入金と相殺を除外 (完全一致)
      current_sales_conditions = ProsperPost.where.not(modelname: "入金").where.not(modelname: "相殺")
      current_offset_condition = { modelname: "相殺" }
    end

    # --- 過去データ（前月繰越計算用） ---
    past_base = ProsperPost.where(client: client).where.not(nouhinnum: nil).where(lastdate: past_range)

    # 過去の売上
    @past = past_base.where.not(modelnumber: "入金").where.not(past_offset_condition)
    # 過去の入金
    @pastallnyukin = past_base.where(modelnumber: "入金")
    # 過去の相殺
    @pastallsousai = past_base.where(past_offset_condition)

    @urikake1 = ProsperUrikake.where(client: client).where(date: past_range)

    # --- 当月データ ---
    current_base = ProsperPost.where(client: client).where(process: 6).where.not(nouhinnum: nil).where(lastdate: current_range)
    # 特定担当者除外（既存コード踏襲）
    current_base_filtered = current_base.where.not(person: "荻原誠二")

    # 当月の取引一覧
    @post = current_base_filtered.order(lastdate: :asc)

    @q = @post.ransack(params[:q])
    @posts = @q.result(distinct: true).order(lastdate: :asc)
    @postss = @q.result(distinct: true).distinct

    # 当月の売上
    @ageuri = current_base_filtered.merge(current_sales_conditions)

    # 当月の相殺
    @minus = current_base_filtered.where(current_offset_condition)

    # 当月の売掛データ
    @urik = ProsperUrikake.where(client: client).where(date: current_range).where.not(bunrui: "6-相殺")
  end


end
