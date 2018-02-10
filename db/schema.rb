# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20180210191805) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "announcements", force: :cascade do |t|
    t.text "title", null: false
    t.text "body", null: false
    t.boolean "pinned", default: false, null: false
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_announcements_on_user_id"
  end

  create_table "categories", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_categories_on_name", unique: true
  end

  create_table "category_metadata_types", force: :cascade do |t|
    t.string "name", null: false
    t.integer "field_type", null: false
    t.integer "metadata_for", null: false
    t.bigint "category_id"
    t.text "options", array: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "help_text"
    t.index ["category_id"], name: "index_category_metadata_types_on_category_id"
  end

  create_table "peers", force: :cascade do |t|
    t.bigint "user_id"
    t.bigint "torrent_id"
    t.inet "ip", null: false
    t.boolean "active", default: true, null: false
    t.integer "announced", default: 0, null: false
    t.boolean "completed", default: false, null: false
    t.bigint "downloaded", default: 0, null: false
    t.bigint "uploaded", default: 0, null: false
    t.bigint "remaining", default: 0, null: false
    t.integer "upspeed", default: 0, null: false
    t.integer "downspeed", default: 0, null: false
    t.integer "timespent", default: 0, null: false
    t.integer "corrupt", default: 0, null: false
    t.text "user_agent", default: "", null: false
    t.boolean "connectable", default: true, null: false
    t.binary "peer_id", default: "0", null: false
    t.integer "port", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["torrent_id"], name: "index_peers_on_torrent_id"
    t.index ["torrent_id"], name: "torrent_by_active", where: "active"
    t.index ["user_id"], name: "index_peers_on_user_id"
  end

  create_table "release_metadata", force: :cascade do |t|
    t.bigint "release_id"
    t.string "name"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["release_id"], name: "index_release_metadata_on_release_id"
  end

  create_table "releases", force: :cascade do |t|
    t.string "name", null: false
    t.integer "year"
    t.text "description"
    t.bigint "category_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_releases_on_category_id"
  end

  create_table "search_fields", force: :cascade do |t|
    t.text "name", null: false
    t.text "title"
    t.integer "kind", default: 0, null: false
    t.text "options", array: true
    t.integer "sort_order", null: false
    t.jsonb "misc", default: "{}"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "category_id"
    t.integer "search_type", default: 0, null: false
    t.index ["category_id"], name: "index_search_fields_on_category_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "var", null: false
    t.text "value"
    t.integer "thing_id"
    t.string "thing_type", limit: 30
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true
  end

  create_table "torrent_files", force: :cascade do |t|
    t.bigint "torrent_id"
    t.binary "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["torrent_id"], name: "index_torrent_files_on_torrent_id"
  end

  create_table "torrent_metadata", force: :cascade do |t|
    t.bigint "torrent_id"
    t.string "name"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["torrent_id"], name: "index_torrent_metadata_on_torrent_id"
  end

  create_table "torrents", force: :cascade do |t|
    t.string "info_hash", null: false
    t.string "name", null: false
    t.integer "file_count", null: false
    t.text "file_list", default: [], null: false, array: true
    t.text "file_path", default: [], null: false, array: true
    t.bigint "size", default: 0, null: false
    t.integer "leechers", default: 0, null: false
    t.integer "seeders", default: 0, null: false
    t.integer "leech"
    t.integer "freeleech_type"
    t.integer "snatched", default: 0, null: false
    t.bigint "balance"
    t.bigint "release_id"
    t.datetime "last_reseed_request"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["info_hash"], name: "index_torrents_on_info_hash", unique: true
    t.index ["release_id"], name: "index_torrents_on_release_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.integer "role", default: 0, null: false
    t.string "username", null: false
    t.string "torrent_pass", null: false
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.integer "failed_attempts", default: 0, null: false
    t.string "unlock_token"
    t.datetime "locked_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "bonus_upload"
    t.bigint "uploaded"
    t.bigint "downloaded"
    t.integer "invites"
    t.bigint "bonus_points"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["torrent_pass"], name: "index_users_on_torrent_pass", unique: true
  end

  add_foreign_key "announcements", "users"
  add_foreign_key "category_metadata_types", "categories"
  add_foreign_key "peers", "torrents"
  add_foreign_key "peers", "users"
  add_foreign_key "release_metadata", "releases"
  add_foreign_key "releases", "categories"
  add_foreign_key "search_fields", "categories"
  add_foreign_key "torrent_files", "torrents"
  add_foreign_key "torrent_metadata", "torrents"
  add_foreign_key "torrents", "releases"
end
