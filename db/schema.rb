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

ActiveRecord::Schema[8.0].define(version: 2025_08_22_091625) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "destiny_damage_types", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destiny_energy_types", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destiny_inventory_buckets", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destiny_inventory_item_stats", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destiny_inventory_items", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.string "name"
    t.string "description"
    t.string "flavour_text"
    t.integer "item_type"
    t.integer "item_subtype"
    t.integer "guardian_type"
    t.integer "tier_type"
    t.integer "breaker_type"
    t.boolean "is_equippable"
    t.boolean "is_featured"
    t.boolean "is_holofoil"
    t.boolean "is_adept"
    t.boolean "is_redacted"
    t.boolean "is_blacklisted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destiny_item_categories", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.string "name"
    t.string "description"
    t.integer "item_type"
    t.integer "item_sub_type"
    t.integer "guardian_type"
    t.integer "breaker_type"
    t.boolean "is_plug"
    t.boolean "is_deprecated"
    t.boolean "is_visible"
    t.boolean "is_redacted"
    t.boolean "is_blacklisted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destiny_memberships", force: :cascade do |t|
    t.bigint "membership_id"
    t.integer "membership_type"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destiny_socket_types", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destiny_stats", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.string "name"
    t.string "description"
    t.string "icon_url"
    t.integer "aggregation_type"
    t.integer "category"
    t.boolean "has_icon"
    t.boolean "is_redacted"
    t.boolean "is_blacklisted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destiny_traits", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.string "name"
    t.string "description"
    t.boolean "is_redacted"
    t.boolean "is_blacklisted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end
end
