# app/controllers/stone_parts_controller.rb
class StonePartsController < ApplicationController
  before_action :set_stone_part, only: [:show, :edit, :update, :destroy]
  # before_action :require_login

  def index
    @stone_parts = StonePart.all.order(:code)
    respond_to do |format|
      format.html
      format.csv { send_data StonePart.to_csv, filename: "stone_parts-#{Date.today}.csv" }
    end
  end

  def show
  end

  def new
    @stone_part = StonePart.new
  end

  def edit
  end

  def create
    @stone_part = StonePart.new(stone_part_params)

    respond_to do |format|
      if @stone_part.save
        format.html { redirect_to @stone_part, notice: '石パーツが正常に登録されました。' }
        format.json { render :show, status: :created, location: @stone_part }
      else
        format.html { render :new }
        format.json { render json: @stone_part.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @stone_part.update(stone_part_params)
        format.html { redirect_to @stone_part, notice: '石パーツが正常に更新されました。' }
        format.json { render :show, status: :ok, location: @stone_part }
      else
        format.html { render :edit }
        format.json { render json: @stone_part.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @stone_part.destroy
        format.html { redirect_to stone_parts_url, notice: '石パーツが正常に削除されました。' }
        format.json { head :no_content }
      else
        format.html { redirect_to stone_parts_url, alert: '石パーツの削除に失敗しました。関連する商品が存在する可能性があります。' }
        format.json { render json: @stone_part.errors, status: :unprocessable_entity }
      end
    end
  end

  def export
    respond_to do |format|
      format.csv { send_data StonePart.to_csv, filename: "stone_parts-#{Date.today}.csv" }
    end
  end

  private
    def set_stone_part
      @stone_part = StonePart.find(params[:id])
    end

    def stone_part_params
      params.require(:stone_part).permit(
        :code, :name, :stone_type, :format_type, :size, :specific_gravity,
        :color, :clarity, :market_price, :active
      )
    end
end
