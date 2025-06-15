# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_04_28_125453) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "categories", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "parent_id"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_categories_on_code", unique: true
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "clients", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "name_kana"
    t.string "alternate_name"
    t.string "postal_code"
    t.text "address"
    t.integer "billing_cutoff_day"
    t.string "tel"
    t.string "fax"
    t.decimal "unpaid_balance"
    t.decimal "current_balance"
    t.string "contact_person"
    t.string "email"
    t.string "payment_terms"
    t.decimal "credit_limit"
    t.string "client_type"
    t.boolean "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_clients_on_code", unique: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name"
    t.string "company_id"
    t.string "address"
    t.string "phone"
    t.string "email"
    t.integer "max_users"
    t.integer "admin_licenses"
    t.integer "staff_licenses"
    t.boolean "is_owner"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "material_price_histories", force: :cascade do |t|
    t.bigint "material_id", null: false
    t.decimal "price", precision: 10, scale: 2, null: false
    t.datetime "effective_from", null: false
    t.datetime "effective_to"
    t.bigint "recorded_by_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_id"], name: "index_material_price_histories_on_material_id"
    t.index ["recorded_by_id"], name: "index_material_price_histories_on_recorded_by_id"
  end

  create_table "materials", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.decimal "market_price"
    t.decimal "specific_gravity"
    t.decimal "platinum_rate"
    t.decimal "gold_rate"
    t.decimal "palladium_rate"
    t.decimal "silver_rate"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_materials_on_code", unique: true
  end

  create_table "parts", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "shape"
    t.string "material_type"
    t.decimal "market_price"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_parts_on_code", unique: true
  end

  create_table "product_images", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.integer "sequence"
    t.string "filename"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_images_on_product_id"
  end

  create_table "product_materials", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "material_id", null: false
    t.integer "sequence"
    t.decimal "quantity", precision: 8, scale: 3
    t.decimal "casting_weight", precision: 8, scale: 3
    t.decimal "finishing_weight", precision: 8, scale: 3
    t.decimal "wage", precision: 10, scale: 2
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["material_id"], name: "index_product_materials_on_material_id"
    t.index ["product_id"], name: "index_product_materials_on_product_id"
  end

  create_table "product_stone_parts", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.bigint "stone_part_id", null: false
    t.integer "sequence"
    t.string "format"
    t.string "size_info"
    t.string "shape"
    t.string "kind"
    t.decimal "carat_per_piece", precision: 8, scale: 4
    t.decimal "carat", precision: 8, scale: 4
    t.integer "quantity"
    t.decimal "unit_price", precision: 10, scale: 2
    t.decimal "wage", precision: 10, scale: 2
    t.string "supply_status"
    t.text "note"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["product_id"], name: "index_product_stone_parts_on_product_id"
    t.index ["stone_part_id"], name: "index_product_stone_parts_on_stone_part_id"
  end

  create_table "productions", force: :cascade do |t|
    t.bigint "product_id", null: false
    t.decimal "prototype_weight", precision: 8, scale: 3
    t.decimal "prototype_price", precision: 10, scale: 2
    t.decimal "prototype_cost", precision: 10, scale: 2
    t.date "prototype_date"
    t.string "prototype_size"
    t.bigint "prototype_maker_id"
    t.bigint "cast_supplier_id"
    t.bigint "polish_supplier_id"
    t.bigint "stone_setting_supplier_id"
    t.bigint "finishing_supplier_id"
    t.decimal "cast_wage", precision: 10, scale: 2
    t.decimal "polish_wage", precision: 10, scale: 2
    t.decimal "stone_setting_wage", precision: 10, scale: 2
    t.decimal "finishing_wage", precision: 10, scale: 2
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cast_supplier_id"], name: "index_productions_on_cast_supplier_id"
    t.index ["finishing_supplier_id"], name: "index_productions_on_finishing_supplier_id"
    t.index ["polish_supplier_id"], name: "index_productions_on_polish_supplier_id"
    t.index ["product_id"], name: "index_productions_on_product_id"
    t.index ["prototype_maker_id"], name: "index_productions_on_prototype_maker_id"
    t.index ["stone_setting_supplier_id"], name: "index_productions_on_stone_setting_supplier_id"
  end

  create_table "products", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.bigint "client_id"
    t.string "client_code"
    t.bigint "person_id"
    t.text "casting_note"
    t.text "polish_note"
    t.bigint "category_id"
    t.string "project_name"
    t.string "engraved"
    t.text "note1"
    t.text "note2"
    t.decimal "price", precision: 10, scale: 2
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_products_on_category_id"
    t.index ["client_id"], name: "index_products_on_client_id"
    t.index ["code"], name: "index_products_on_code", unique: true
    t.index ["person_id"], name: "index_products_on_person_id"
  end

  create_table "stone_parts", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "stone_type"
    t.string "format_type"
    t.decimal "size"
    t.decimal "specific_gravity"
    t.string "color"
    t.string "clarity"
    t.decimal "market_price"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_stone_parts_on_code", unique: true
  end

  create_table "suppliers", force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "type"
    t.string "tel"
    t.text "address"
    t.string "contact_person"
    t.string "email"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_suppliers_on_code", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "password"
    t.bigint "company_id", null: false
    t.string "user_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_users_on_company_id"
  end

  add_foreign_key "categories", "categories", column: "parent_id"
  add_foreign_key "material_price_histories", "materials"
  add_foreign_key "material_price_histories", "users", column: "recorded_by_id"
  add_foreign_key "product_images", "products"
  add_foreign_key "product_materials", "materials"
  add_foreign_key "product_materials", "products"
  add_foreign_key "product_stone_parts", "products"
  add_foreign_key "product_stone_parts", "stone_parts"
  add_foreign_key "productions", "products"
  add_foreign_key "productions", "suppliers", column: "cast_supplier_id"
  add_foreign_key "productions", "suppliers", column: "finishing_supplier_id"
  add_foreign_key "productions", "suppliers", column: "polish_supplier_id"
  add_foreign_key "productions", "suppliers", column: "prototype_maker_id"
  add_foreign_key "productions", "suppliers", column: "stone_setting_supplier_id"
  add_foreign_key "products", "categories"
  add_foreign_key "products", "clients"
  add_foreign_key "products", "users", column: "person_id"
  add_foreign_key "users", "companies"
end
