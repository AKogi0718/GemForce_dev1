# db/seeds.rb
# システム提供元の会社（自社）の作成
owner_company = Company.create!(
  name: "有限会社栄泉",
  company_id: "1000",
  address: "山梨県笛吹市御坂町井之上762-1",
  phone: "03-1234-5678",
  email: "oseijiogi@gmail.com",
  max_users: 10,
  admin_licenses: 5,
  staff_licenses: 5,
  is_owner: true
)

# システム管理者の作成
User.create!(
  name: "システム管理者",
  email: "admin@gemforce.co.jp",
  password: "password",
  user_type: "system_admin",
  company_id: owner_company.id
)

puts "初期データの作成が完了しました"
