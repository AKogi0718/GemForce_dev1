# app/models/company.rb
class Company < ApplicationRecord
  has_many :users, dependent: :destroy

  validates :name, presence: true
  validates :company_id, presence: true, uniqueness: true
  validates :max_users, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :admin_licenses, numericality: { only_integer: true, greater_than_or_equal_to: 0 }
  validates :staff_licenses, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  # システム提供元の会社かどうか
  def owner?
    is_owner
  end

  # 使用中の担当者ライセンス数を取得
  def used_staff_licenses
    users.where(user_type: 'staff').count
  end

  # 使用中の管理者ライセンス数を取得
  def used_admin_licenses
    users.where(user_type: 'admin').count
  end

  # 残りの担当者ライセンス数を取得
  def remaining_staff_licenses
    staff_licenses - used_staff_licenses
  end

  # 残りの管理者ライセンス数を取得
  def remaining_admin_licenses
    admin_licenses - used_admin_licenses
  end

  # 新しいユーザーを追加できるかチェック
  def can_add_user?(user_type)
    return false if users.count >= max_users

    case user_type
    when 'staff'
      remaining_staff_licenses > 0
    when 'admin'
      remaining_admin_licenses > 0
    when 'system_admin'
      # システム管理者は自社のみ追加可能
      is_owner
    else
      false
    end
  end

  # 特定のユーザータイプに変更できるかチェック
  def can_change_user_type?(user, new_type)
    return true if user.user_type == new_type

    case new_type
    when 'staff'
      remaining_staff_licenses > 0
    when 'admin'
      remaining_admin_licenses > 0
    when 'system_admin'
      # システム管理者は自社のみ変更可能
      is_owner
    else
      false
    end
  end
end
