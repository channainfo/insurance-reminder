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

ActiveRecord::Schema.define(version: 20150331024731) do

  create_table "calls", force: :cascade do |t|
    t.integer  "client_id",        limit: 4
    t.integer  "main_id",          limit: 4
    t.string   "status",           limit: 255, default: "Pending"
    t.date     "expiration_date"
    t.string   "phone_number",     limit: 255
    t.datetime "update_status_at"
    t.integer  "calls_count",      limit: 4,   default: 0
    t.datetime "created_at",                                       null: false
    t.datetime "updated_at",                                       null: false
    t.integer  "verboice_call_id", limit: 4
    t.string   "family_code",      limit: 255
    t.integer  "kind",             limit: 4,   default: 1
    t.integer  "od_id",            limit: 4
    t.string   "full_name",        limit: 255
  end

  add_index "calls", ["client_id"], name: "index_calls_on_client_id", using: :btree
  add_index "calls", ["main_id"], name: "index_calls_on_main_id", using: :btree

  create_table "clients", force: :cascade do |t|
    t.string   "phone_number",    limit: 255
    t.string   "family_code",     limit: 255
    t.date     "expiration_date"
    t.datetime "created_at",                              null: false
    t.datetime "updated_at",                              null: false
    t.integer  "number_retry",    limit: 4,   default: 0
    t.integer  "calls_count",     limit: 4,   default: 0
    t.string   "full_name",       limit: 255
    t.integer  "beneficiary_id",  limit: 4
    t.integer  "kind",            limit: 4,   default: 1
    t.integer  "od_id",           limit: 4
  end

  create_table "expirations", force: :cascade do |t|
    t.date     "date"
    t.text     "clients",    limit: 65535
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
  end

  add_index "expirations", ["date"], name: "index_expirations_on_date", using: :btree

  create_table "operational_districts", force: :cascade do |t|
    t.string   "name",            limit: 255
    t.string   "code",            limit: 255
    t.integer  "external_id",     limit: 4
    t.boolean  "enable_reminder", limit: 1
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

  create_table "settings", force: :cascade do |t|
    t.string   "var",        limit: 255,   null: false
    t.text     "value",      limit: 65535
    t.integer  "thing_id",   limit: 4
    t.string   "thing_type", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "settings", ["thing_type", "thing_id", "var"], name: "index_settings_on_thing_type_and_thing_id_and_var", unique: true, using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 255
    t.string   "name",            limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                                     null: false
    t.datetime "updated_at",                                     null: false
    t.string   "role",            limit: 255,   default: "User"
    t.text     "ods",             limit: 65535
  end

end
