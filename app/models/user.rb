# app/models/user.rb
class User < ApplicationRecord
  belongs_to :company

  validates :name, presence: true
  validates :email, presence: true, uniqueness: { scope: :company_id }
  validates :password, presence: true, length: { minimum: 6 }
  validates :user_type, presence: true, inclusion: { in: ['staff', 'admin', 'system_admin'] }

  # 担当者かどうか
  def staff?
    user_type == 'staff'
  end

  # 管理者かどうか
  def admin?
    user_type == 'admin'
  end

  # システム管理者かどうか
  def system_admin?
    user_type == 'system_admin'
  end

  # ユーザー認証用クラスメソッド
  def self.authenticate(company_id, email, password)
    company = Company.find_by(company_id: company_id)
    return nil unless company

    user = User.find_by(company_id: company.id, email: email, password: password)
    return user if user
    nil
  end

  # ユーザー作成前にライセンスのチェックを行う
  before_create :check_license_availability

  private

  def check_license_availability
    unless company.can_add_user?(user_type)
      case user_type
      when 'staff'
        errors.add(:base, "会社の担当者ライセンスが不足しています")
      when 'admin'
        errors.add(:base, "会社の管理者ライセンスが不足しています")
      when 'system_admin'
        errors.add(:base, "システム管理者は自社のみ追加できます")
      end
      throw :abort
    end
  end
end
