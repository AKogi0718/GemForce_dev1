# app/controllers/companies_controller.rb
class CompaniesController < ApplicationController
  before_action :authenticate_user
  before_action :ensure_system_admin, except: [:show]
  before_action :set_company, only: [:show, :edit, :update]

  def index
    @companies = Company.all
  end

  def show
    # 現在のユーザーが属する会社か、システム管理者のみ閲覧可能
    unless @current_user.company_id == @company.id || @current_user.system_admin?
      flash[:notice] = "アクセス権限がありません"
      redirect_to("/users/#{@current_user.id}")
      return
    end
  end

  def new
    @company = Company.new
  end

  def create
    @company = Company.new(company_params)

    if @company.save
      flash[:notice] = "会社を登録しました"
      redirect_to("/companies/#{@company.id}")
    else
      render("companies/new")
    end
  end

  def edit
  end

  def update
    if @company.update(company_params)
      flash[:notice] = "会社情報を更新しました"
      redirect_to("/companies/#{@company.id}")
    else
      render("companies/edit")
    end
  end

  private

  def set_company
    @company = Company.find_by(id: params[:id])
    if @company.nil?
      flash[:notice] = "会社が見つかりません"
      redirect_to("/companies")
    end
  end

  def company_params
    params.require(:company).permit(
      :name, :company_id, :address, :phone, :email,
      :max_users, :admin_licenses, :staff_licenses, :is_owner
    )
  end
end
