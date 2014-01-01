# encoding: UTF-8
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

ActiveRecord::Schema.define(version: 20131228152020) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "common_activities", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "common_activities", ["name"], name: "index_common_activities_on_name", unique: true, using: :btree

  create_table "common_activity_associations", force: true do |t|
    t.integer  "activity_id", null: false
    t.integer  "trail_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "common_activity_associations", ["activity_id", "trail_id"], name: "index_common_activity_associations_on_activity_id_and_trail_id", unique: true, using: :btree
  add_index "common_activity_associations", ["activity_id"], name: "index_common_activity_associations_on_activity_id", using: :btree
  add_index "common_activity_associations", ["trail_id"], name: "index_common_activity_associations_on_trail_id", using: :btree

  create_table "common_missing_trails", force: true do |t|
    t.string   "user_name",               null: false
    t.string   "user_email",              null: false
    t.string   "info",       limit: 1000, null: false
    t.string   "updates",    limit: 5000
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "common_missing_trails", ["created_at"], name: "index_common_missing_trails_on_created_at", using: :btree

  create_table "common_states", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "common_states", ["name"], name: "index_common_states_on_name", unique: true, using: :btree

  create_table "common_trails", force: true do |t|
    t.string   "name",        limit: 75,                         null: false
    t.decimal  "length",                 precision: 5, scale: 2
    t.text     "description"
    t.integer  "state_id",                                       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "common_trails", ["name", "state_id"], name: "index_common_trails_on_name_and_state_id", unique: true, using: :btree
  add_index "common_trails", ["name"], name: "index_common_trails_on_name", using: :btree
  add_index "common_trails", ["state_id"], name: "index_common_trails_on_state_id", using: :btree

  create_table "community_trade_associations", force: true do |t|
    t.integer  "trade_id",         null: false
    t.integer  "user_id",          null: false
    t.string   "association_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "community_trade_associations", ["trade_id"], name: "index_community_trade_associations_on_trade_id", using: :btree
  add_index "community_trade_associations", ["user_id", "trade_id"], name: "index_community_trade_associations_on_user_id_and_trade_id", unique: true, using: :btree
  add_index "community_trade_associations", ["user_id"], name: "index_community_trade_associations_on_user_id", using: :btree

  create_table "community_trades", force: true do |t|
    t.integer  "trader_id",                                              null: false
    t.string   "trade_type",                                             null: false
    t.string   "gear",                                                   null: false
    t.text     "description",                                            null: false
    t.integer  "activity_id"
    t.string   "trade_location",                                         null: false
    t.boolean  "completed",                              default: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "price",          precision: 6, scale: 2, default: 0.0
  end

  add_index "community_trades", ["completed"], name: "index_community_trades_on_completed", using: :btree
  add_index "community_trades", ["gear"], name: "index_community_trades_on_gear", using: :btree
  add_index "community_trades", ["price"], name: "index_community_trades_on_price", using: :btree
  add_index "community_trades", ["trade_type"], name: "index_community_trades_on_trade_type", using: :btree

  create_table "community_updates", force: true do |t|
    t.text     "content",    null: false
    t.integer  "author_id",  null: false
    t.integer  "trail_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "corner_favorite_activities", force: true do |t|
    t.integer  "user_id",     null: false
    t.integer  "activity_id", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "corner_favorite_activities", ["activity_id"], name: "index_corner_favorite_activities_on_activity_id", using: :btree
  add_index "corner_favorite_activities", ["user_id", "activity_id"], name: "index_corner_favorite_activities_on_user_id_and_activity_id", unique: true, using: :btree
  add_index "corner_favorite_activities", ["user_id"], name: "index_corner_favorite_activities_on_user_id", using: :btree

  create_table "corner_favorite_trails", force: true do |t|
    t.integer  "user_id",    null: false
    t.integer  "trail_id",   null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "corner_favorite_trails", ["trail_id"], name: "index_corner_favorite_trails_on_trail_id", using: :btree
  add_index "corner_favorite_trails", ["user_id", "trail_id"], name: "index_corner_favorite_trails_on_user_id_and_trail_id", unique: true, using: :btree
  add_index "corner_favorite_trails", ["user_id"], name: "index_corner_favorite_trails_on_user_id", using: :btree

  create_table "corner_favorite_users", force: true do |t|
    t.integer  "fan_id",     null: false
    t.integer  "star_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "corner_favorite_users", ["fan_id", "star_id"], name: "index_corner_favorite_users_on_fan_id_and_star_id", unique: true, using: :btree
  add_index "corner_favorite_users", ["fan_id"], name: "index_corner_favorite_users_on_fan_id", using: :btree
  add_index "corner_favorite_users", ["star_id"], name: "index_corner_favorite_users_on_star_id", using: :btree

  create_table "corner_logs", force: true do |t|
    t.integer  "user_id",                 null: false
    t.string   "title",       limit: 100, null: false
    t.text     "content",                 null: false
    t.integer  "activity_id"
    t.date     "log_date",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "corner_logs", ["log_date"], name: "index_corner_logs_on_log_date", using: :btree
  add_index "corner_logs", ["user_id", "activity_id"], name: "index_corner_logs_on_user_id_and_activity_id", using: :btree
  add_index "corner_logs", ["user_id"], name: "index_corner_logs_on_user_id", using: :btree

  create_table "site_tag_associations", force: true do |t|
    t.integer  "tag_id",        null: false
    t.integer  "taggable_id",   null: false
    t.string   "taggable_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "site_tag_associations", ["tag_id", "taggable_id", "taggable_type"], name: "by_tag_in_taggable_item", unique: true, using: :btree
  add_index "site_tag_associations", ["tag_id"], name: "index_site_tag_associations_on_tag_id", using: :btree
  add_index "site_tag_associations", ["taggable_id", "taggable_type"], name: "by_taggable_item", using: :btree

  create_table "site_tags", force: true do |t|
    t.string   "name",       null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "site_tags", ["name"], name: "index_site_tags_on_name", unique: true, using: :btree

  create_table "site_user_requests", force: true do |t|
    t.string   "email",        null: false
    t.string   "token",        null: false
    t.string   "request_type", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "site_user_requests", ["created_at"], name: "index_site_user_requests_on_created_at", using: :btree
  add_index "site_user_requests", ["email"], name: "index_site_user_requests_on_email", using: :btree
  add_index "site_user_requests", ["token"], name: "index_site_user_requests_on_token", using: :btree

  create_table "users", force: true do |t|
    t.string   "login_id",        limit: 50,                 null: false
    t.string   "name",            limit: 50,                 null: false
    t.string   "email",                                      null: false
    t.string   "password_digest",                            null: false
    t.boolean  "admin",                      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "users", ["login_id"], name: "index_users_on_login_id", unique: true, using: :btree

end
