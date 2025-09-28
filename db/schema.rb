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

ActiveRecord::Schema[8.0].define(version: 2025_09_28_015051) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "destiny_characters", force: :cascade do |t|
    t.bigint "character_hash"
    t.bigint "membership_hash"
    t.bigint "emblem_hash"
    t.integer "race"
    t.integer "gender"
    t.integer "guardian_type"
    t.datetime "last_played_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["character_hash", "membership_hash"], name: "index_destiny_characters_on_character_hash_and_membership_hash", unique: true
  end

  create_table "destiny_inventory_buckets", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.boolean "is_redacted", default: false
    t.boolean "is_blacklisted", default: false
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bungie_hash"], name: "index_destiny_inventory_buckets_on_bungie_hash", unique: true
  end

  create_table "destiny_inventory_item_categories", id: false, force: :cascade do |t|
    t.bigint "inventory_item_hash"
    t.bigint "category_hash"
    t.index ["inventory_item_hash", "category_hash"], name: "idx_on_inventory_item_hash_category_hash_d1c65d9775", unique: true
  end

  create_table "destiny_inventory_item_instances", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "instance_hash"
    t.bigint "inventory_bucket_hash"
    t.bigint "location"
    t.bigint "membership_hash"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state", default: 0
    t.integer "bind_status", default: 0
    t.integer "transfer_status", default: 0
    t.integer "quantity", default: 0
    t.boolean "is_lockable", default: false
    t.bigint "override_style_hash"
    t.bigint "character_hash"
    t.index ["instance_hash"], name: "index_destiny_inventory_item_instances_on_instance_hash", unique: true
    t.index ["membership_hash"], name: "index_destiny_inventory_item_instances_on_membership_hash"
  end

  create_table "destiny_inventory_item_stats", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.boolean "is_redacted", default: false
    t.boolean "is_blacklisted", default: false
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bungie_hash"], name: "index_destiny_inventory_item_stats_on_bungie_hash", unique: true
  end

  create_table "destiny_inventory_item_traits", id: false, force: :cascade do |t|
    t.bigint "inventory_item_hash"
    t.bigint "trait_hash"
    t.index ["inventory_item_hash", "trait_hash"], name: "idx_on_inventory_item_hash_trait_hash_bfbf5cfdae", unique: true
  end

  create_table "destiny_inventory_items", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.boolean "is_redacted", default: false
    t.boolean "is_blacklisted", default: false
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "flavour_text"
    t.integer "guardian_type"
    t.integer "tier_type"
    t.integer "breaker_type"
    t.boolean "is_equippable"
    t.boolean "is_featured"
    t.boolean "is_holofoil"
    t.boolean "is_adept"
    t.bigint "inventory_bucket_hash"
    t.boolean "has_icon", default: false
    t.string "icon_url"
    t.string "high_res_icon_url"
    t.string "display_name"
    t.string "screenshot_url"
    t.index ["bungie_hash"], name: "index_destiny_inventory_items_on_bungie_hash", unique: true
  end

  create_table "destiny_item_categories", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.boolean "is_redacted", default: false
    t.boolean "is_blacklisted", default: false
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_plug", default: false
    t.boolean "is_deprecated", default: false
    t.boolean "is_visible", default: false
    t.index ["bungie_hash"], name: "index_destiny_item_categories_on_bungie_hash", unique: true
  end

  create_table "destiny_memberships", force: :cascade do |t|
    t.bigint "membership_hash"
    t.integer "membership_type"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["membership_hash"], name: "index_destiny_memberships_on_membership_hash", unique: true
  end

  create_table "destiny_plug_set_items", force: :cascade do |t|
    t.bigint "plug_set_hash"
    t.bigint "inventory_item_hash"
    t.boolean "can_roll"
    t.float "weight"
    t.float "alternate_weight"
    t.index ["plug_set_hash", "inventory_item_hash"], name: "idx_on_plug_set_hash_inventory_item_hash_af98481650", unique: true
  end

  create_table "destiny_plug_sets", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.boolean "is_redacted", default: false
    t.boolean "is_blacklisted", default: false
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "is_fake", default: false
    t.index ["bungie_hash"], name: "index_destiny_plug_sets_on_bungie_hash", unique: true
  end

  create_table "destiny_seasons", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.boolean "is_redacted", default: false
    t.boolean "is_blacklisted", default: false
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "number"
    t.boolean "has_icon", default: false
    t.string "icon_url"
    t.index ["bungie_hash"], name: "index_destiny_seasons_on_bungie_hash", unique: true
  end

  create_table "destiny_socket_categories", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "destiny_socket_types", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.boolean "is_redacted", default: false
    t.boolean "is_blacklisted", default: false
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bungie_hash"], name: "index_destiny_socket_types_on_bungie_hash", unique: true
  end

  create_table "destiny_stats", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.boolean "is_redacted", default: false
    t.boolean "is_blacklisted", default: false
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "aggregation_type"
    t.integer "category"
    t.index ["bungie_hash"], name: "index_destiny_stats_on_bungie_hash", unique: true
  end

  create_table "destiny_traits", force: :cascade do |t|
    t.bigint "bungie_hash"
    t.bigint "index"
    t.boolean "is_redacted", default: false
    t.boolean "is_blacklisted", default: false
    t.string "name"
    t.string "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "has_icon", default: false
    t.string "icon_url"
    t.index ["bungie_hash"], name: "index_destiny_traits_on_bungie_hash", unique: true
  end
end
