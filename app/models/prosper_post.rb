# app/models/prosper_post.rb
class ProsperPost < ProsperBase
  self.table_name = 'posts'

  # Ransack用の検索許可リスト設定 (ホワイトリスト)
  def self.ransackable_attributes(auth_object = nil)
    # 検索・ソート対象とするカラム名を配列で指定します。
    # 請求処理で使われる主要なカラムをリストアップしています。
    %w[
      id process created_at updated_at client nouhinnum lastdate modelnumber
      modelname person castprint nouhinprintdone nouhinprint company
      castorder dashine lastamount finaldate cdate lot wage ordering
    ]
  end

  # 関連モデル経由で検索する場合に指定します（今回は空でOKです）
  def self.ransackable_associations(auth_object = nil)
    []
  end
end
