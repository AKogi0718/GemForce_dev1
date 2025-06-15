class Client < ApplicationRecord
  def self.to_csv
  CSV.generate(headers: true) do |csv|
    csv << [
      'コード', '取引先名', 'フリガナ', '代替名称', '郵便番号', '住所', '電話番号',
      'FAX番号', '締め日', '担当者', 'メールアドレス', '現在残高', '未払残高',
      '顧客タイプ', '状態'
    ]

    all.each do |client|
      csv << [
        client.code,
        client.name,
        client.name_kana,
        client.alternate_name,
        client.postal_code,
        client.address,
        client.tel,
        client.fax,
        client.billing_cutoff_day,
        client.contact_person,
        client.email,
        client.current_balance,
        client.unpaid_balance,
        client.client_type,
        client.status ? '有効' : '無効'
      ]
    end
  end
end
end
