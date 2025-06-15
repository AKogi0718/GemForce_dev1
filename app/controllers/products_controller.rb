class ProductsController < ApplicationController
  before_action :set_product, only: [:show, :edit, :update, :destroy]

  def index
    @products = Product.includes(:client, :category).all

    respond_to do |format|
      format.html
      format.csv { send_data Product.to_csv, filename: "products-#{Date.today}.csv" }
    end
  end

  def show
  end

  def new
    @product = Product.new
    @product.build_production  # Production の初期化
    @product.product_materials.build  # ProductMaterial の初期化
    @product.product_stone_parts.build  # ProductStonePart の初期化
    @product.product_images.build  # ProductImage の初期化

    # 選択肢のリストを用意
    @stone_shapes = stone_shapes_list
    @stone_kinds = stone_kinds_list
  end

  def edit
    # 選択肢のリストを用意
    @stone_shapes = stone_shapes_list
    @stone_kinds = stone_kinds_list
  end

  def create
    @product = Product.new(product_params)

    respond_to do |format|
      if @product.save
        format.html { redirect_to @product, notice: '商品が正常に登録されました。' }
        format.json { render :show, status: :created, location: @product }
      else
        format.html { render :new }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @product.update(product_params)
        format.html { redirect_to @product, notice: '商品が正常に更新されました。' }
        format.json { render :show, status: :ok, location: @product }
      else
        format.html { render :edit }
        format.json { render json: @product.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @product.destroy
    respond_to do |format|
      format.html { redirect_to products_url, notice: '商品が正常に削除されました。' }
      format.json { head :no_content }
    end
  end

  private
    def set_product
      @product = Product.includes(
        :client,
        :category,
        :production,
        product_materials: [:material],
        product_stone_parts: [:stone_part],
        product_images: []
      ).find(params[:id])
    end

    def product_params
      params.require(:product).permit(
        :code, :name, :client_id, :client_code, :person_id, :casting_note,
        :polish_note, :category_id, :project_name, :engraved, :note1, :note2,
        :price, :active,
        production_attributes: [
          :id, :prototype_weight, :prototype_price, :prototype_cost, :prototype_date,
          :prototype_size, :prototype_maker_id, :cast_supplier_id, :polish_supplier_id,
          :stone_setting_supplier_id, :finishing_supplier_id, :cast_wage, :polish_wage,
          :stone_setting_wage, :finishing_wage
        ],
        product_materials_attributes: [
          :id, :material_id, :sequence, :quantity, :casting_weight, :finishing_weight,
          :wage, :note, :_destroy
        ],
        product_stone_parts_attributes: [
          :id, :stone_part_id, :sequence, :format, :size_info, :shape, :kind,
          :carat_per_piece, :carat, :quantity, :unit_price, :wage, :supply_status,
          :note, :_destroy
        ],
        product_images_attributes: [
          :id, :sequence, :filename, :image, :content_type, :_destroy
        ]
      )
    end

    def stone_shapes_list
    [
      'RD', 'MQ', 'OV', 'PS', 'SQ', 'CB', 'BG', 'TP', 'HS', '変形',
      'K10ホワイトM色', 'K10WG', 'K10イエロー', 'K10', 'K10(2:8)', 'K10-9:1', 'K10-6:4',
      'K10WG', 'K10TIO', 'K10真鍮割りYG', 'K10-4:6', 'K10-8:2', 'K10WG-Pd2.9%',
      'K14WG-Pd2%', 'K14WG-Ni', 'K14-5:5', 'K14-8:2', 'K18-6:4', 'K18PG', 'K18-8:2',
      'K18-5:5', 'K18-4:6', 'K18WG-Ni', 'K18WG-Pd3.5%', 'K18WG-Pd5.0%',
      'K18WG-Pd10.0%', 'K18WG-Pd12.5%', 'K18WG-Pd15.0%', 'K18WG-Pd25.0%',
      'K18WG', 'K18WG-Pd7%', 'K18WG-Pd12%', 'K24', 'K18WG-Pd8%', 'K14PG(2:8)',
      'K14WG-Pd6.2%', 'SV', 'SV950', 'SV925', 'ピンクSV', 'SV原型', 'Pt100', 'SV980',
      'Pt1000', 'Pt900', 'Pt900(ハード)', 'Pt850', 'Pt950', 'PD', '真鍮',
      'ステンレス', 'チタン', 'アルミ', '洋白', 'K10B(M)', 'アクリル', 'K10PG-2:8',
      'K10pd3%', 'ETC'
    ]
  end

  def stone_kinds_list
    [
      'OFF D', 'WD', 'DM-etc', 'CB', 'CB-etc', 'CB-EX', 'コットンパール', '貝パール',
      'オパール', 'WT', 'AQ', 'TZ', 'BT', 'PT', 'CT', 'Per', 'IO', 'GA', 'AM',
      '半貴-etc', 'ローズクォーツ', 'ルチル', 'アクリル', 'スモーキークォーツ', 'その他',
      '貴石-etc', 'クォーツ', '淡水-白', '淡水-オレンジ', '淡水-パープル', 'BM',
      'ヘマタイト', 'オニキス', '真珠', 'スワロフスキー', 'プラスチックパール',
      'シンセチック', '商品', '角線', 'タグ', 'ストラップ金具', '玉ピン', 'コイル',
      'ワイヤー', 'つぶし玉', 'パーツ(原型)', 'カットボール', '小豆', '長小豆2C',
      '小豆4C', '丸小豆', '角小豆', 'ベネチアン', 'ボール', 'エスカルゴ', 'スクリュー',
      'キヘイ', 'カワヒモ', 'チェーン-etc', 'キャッチ', 'シリコンキャッチ', '引き輪',
      'プレート', 'EG金具', 'ポスト', '遮断機ポスト', 'ブローチ金具', 'パーツ-etc',
      '丸カン', 'Cカン', 'アジャスター', 'シリコン保護パッド', '9ピン', 'Tピン',
      '丸線', 'フック', '皮ひも', '片シャンク', '両シャンク', '三角シャンク', 'チェーンカット',
      '箱詰め', 'ロー付', '黒イブシ', '白仕上', 'ロジウムメッキ', 'ニッケルロジウムメッキ',
      'ピンクメッキ', 'ブラックロジウムメッキ', '金メッキ', 'ルテメッキ', 'ホーニング',
      'テープ貼り', 'のり付け', 'チェーン付け', 'タグ付け', '袋詰め', 'タグ+袋詰め',
      'チェーン+組立+袋詰', '組立', '樹脂エポのみ', 'レーザー', 'マスキング', 'その他',
      '代用ロジウムメッキ', 'PTメッキ', 'Ptメッキ'
    ]
  end

end
