# app/controllers/materials_controller.rb
class MaterialsController < ApplicationController
  before_action :set_material, only: [:show, :edit, :update, :destroy]
  # before_action :require_login

  def index
    @materials = Material.all.order(:code)
    respond_to do |format|
      format.html
      format.csv { send_data Material.to_csv, filename: "materials-#{Date.today}.csv" }
    end
  end

  def show
  end

  def new
    @material = Material.new
  end

  def edit
  end

  def create
    @material = Material.new(material_params)

    respond_to do |format|
      if @material.save
        format.html { redirect_to @material, notice: '地金が正常に登録されました。' }
        format.json { render :show, status: :created, location: @material }
      else
        format.html { render :new }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    respond_to do |format|
      if @material.update(material_params)
        format.html { redirect_to @material, notice: '地金が正常に更新されました。' }
        format.json { render :show, status: :ok, location: @material }
      else
        format.html { render :edit }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    respond_to do |format|
      if @material.destroy
        format.html { redirect_to materials_url, notice: '地金が正常に削除されました。' }
        format.json { head :no_content }
      else
        format.html { redirect_to materials_url, alert: '地金の削除に失敗しました。関連する商品が存在する可能性があります。' }
        format.json { render json: @material.errors, status: :unprocessable_entity }
      end
    end
  end

  def export
    respond_to do |format|
      format.csv { send_data Material.to_csv, filename: "materials-#{Date.today}.csv" }
    end
  end

  private
    def set_material
      @material = Material.find(params[:id])
    end

    def material_params
      params.require(:material).permit(
        :code, :name, :market_price, :specific_gravity,
        :platinum_rate, :gold_rate, :palladium_rate, :silver_rate, :active
      )
    end
end
