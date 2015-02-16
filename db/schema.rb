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

ActiveRecord::Schema.define(version: 20150216092808) do

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
    t.string   "family_name",     limit: 255
  end

  create_table "users", force: :cascade do |t|
    t.string   "username",        limit: 255
    t.string   "name",            limit: 255
    t.string   "password_digest", limit: 255
    t.datetime "created_at",                  null: false
    t.datetime "updated_at",                  null: false
  end

end
