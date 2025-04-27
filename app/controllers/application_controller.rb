# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  before_action :set_current_user

  protected

  # セッションに基づいて現在のユーザーを設定
  def set_current_user
    @current_user = User.find_by(id: session[:user_id])
  end

  # ユーザー認証チェック
  def authenticate_user
    unless @current_user
      flash[:notice] = "このページにアクセスするにはログインが必要です"
      redirect_to("/login")
    end
  end

  # ログイン済みユーザーのログイン/登録ページへのアクセスを防止
  def forbid_login_user
    if @current_user
      flash[:notice] = "すでにログインしています"
      redirect_to("/users/index")
    end
  end

  # 管理者権限の確認
  def ensure_admin_user
    unless @current_user && (@current_user.admin? || @current_user.system_admin?)
      flash[:notice] = "管理者権限が必要です"
      redirect_to("/users/index")
    end
  end

  # システム管理者権限の確認
  def ensure_system_admin
    unless @current_user && @current_user.system_admin?
      flash[:notice] = "システム管理者権限が必要です"
      redirect_to("/users/index")
    end
  end
end
