# app/controllers/users_controller.rb
class UsersController < ApplicationController
  before_action :authenticate_user, only: [:index, :show, :edit, :update]
  before_action :forbid_login_user, only: [:login_form, :login]
  before_action :ensure_correct_user_or_admin, only: [:edit, :update]
  before_action :set_company, only: [:new, :create]

  def index
    if @current_user.system_admin?
      # システム管理者は全ユーザーを閲覧可能
      @users = User.all.includes(:company)
    elsif @current_user.admin?
      # 管理者は自社内のユーザーのみ閲覧可能
      @users = User.where(company_id: @current_user.company_id)
    else
      # 担当者は自分の情報のみアクセス可能
      redirect_to("/users/#{@current_user.id}")
    end
  end

  def show
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:notice] = "ユーザーが見つかりません"
      redirect_to("/users/index")
      return
    end

    # システム管理者以外は他社のユーザー情報は閲覧不可
    unless @user.company_id == @current_user.company_id || @current_user.system_admin?
      flash[:notice] = "アクセス権限がありません"
      redirect_to("/users/#{@current_user.id}")
    end
  end

  def new
    @user = User.new
    @user_types = get_available_user_types
  end

  def create
    @user = User.new(
      name: params[:name],
      email: params[:email],
      password: params[:password],
      user_type: params[:user_type],
      company_id: @company.id
    )

    if @company.can_add_user?(params[:user_type]) && @user.save
      session[:user_id] = @user.id if session[:user_id].nil?
      flash[:notice] = "ユーザー登録が完了しました"
      redirect_to("/users/#{@user.id}")
    else
      @user_types = get_available_user_types
      render("users/new")
    end
  end

  def edit
    @user = User.find_by(id: params[:id])
    @user_types = get_available_user_types(@user)
  end

  def update
    @user = User.find_by(id: params[:id])

    # 現在と異なるユーザータイプに変更する場合、ライセンス数をチェック
    if params[:user_type] != @user.user_type &&
       !@user.company.can_change_user_type?(@user, params[:user_type])
      @user_types = get_available_user_types(@user)
      @user.errors.add(:user_type, "は変更できません（ライセンス不足）")
      render("users/edit")
      return
    end

    @user.name = params[:name]
    @user.email = params[:email]

    # ユーザータイプは管理者またはシステム管理者のみ変更可能
    if @current_user.admin? || @current_user.system_admin?
      @user.user_type = params[:user_type]
    end

    # パスワードは入力された場合のみ更新
    if params[:password].present?
      @user.password = params[:password]
    end

    if @user.save
      flash[:notice] = "ユーザー情報を更新しました"
      redirect_to("/users/#{@user.id}")
    else
      @user_types = get_available_user_types(@user)
      render("users/edit")
    end
  end

  def login_form
    # フォーム用の初期値を設定
    @company_id = ""
    @email = ""
    @password = ""
  end

  def login
    company = Company.find_by(company_id: params[:company_id])

    if company.nil?
      @error_message = "会社IDが見つかりません"
      @company_id = params[:company_id]
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
      return
    end

    @user = User.find_by(
      company_id: company.id,
      email: params[:email],
      password: params[:password]
    )

    if @user
      session[:user_id] = @user.id
      flash[:notice] = "ログインしました"
      redirect_to users_path
    else
      @error_message = "メールアドレスまたはパスワードが間違っています"
      @company_id = params[:company_id]
      @email = params[:email]
      @password = params[:password]
      render("users/login_form")
    end
  end

  def logout
    session[:user_id] = nil
    flash[:notice] = "ログアウトしました"
    redirect_to("/login")
  end

  private

  def ensure_correct_user_or_admin
    @user = User.find_by(id: params[:id])
    if @user.nil?
      flash[:notice] = "ユーザーが見つかりません"
      redirect_to("/users/index")
      return
    end

    # 自分自身、自社の管理者、またはシステム管理者のみ編集可能
    unless @current_user.id == @user.id ||
          (@current_user.admin? && @current_user.company_id == @user.company_id) ||
          @current_user.system_admin?
      flash[:notice] = "権限がありません"
      redirect_to("/users/index")
    end
  end

  def set_company
    # 新規登録時は会社IDが必要
    company_id = params[:company_id] || params[:user][:company_id]
    @company = Company.find_by(company_id: company_id)

    if @company.nil?
      flash[:notice] = "有効な会社IDが必要です"
      redirect_to("/login")
    end
  end

  # 選択可能なユーザータイプを取得
  def get_available_user_types(user = nil)
    company = user ? user.company : @company
    current_type = user ? user.user_type : nil

    types = []

    # 担当者ライセンス
    staff_available = company.remaining_staff_licenses > 0 || current_type == 'staff'
    types << ['担当者', 'staff', staff_available]

    # 管理者ライセンス
    admin_available = company.remaining_admin_licenses > 0 || current_type == 'admin'
    types << ['管理者', 'admin', admin_available]

    # システム管理者は自社のみ選択可能
    if company.is_owner
      system_admin_available = current_type == 'system_admin' ||
                               (@current_user && @current_user.system_admin?)
      types << ['システム管理者', 'system_admin', system_admin_available]
    end

    types
  end
end
