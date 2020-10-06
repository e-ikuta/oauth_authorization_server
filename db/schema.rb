# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_10_06_152722) do

  create_table "approved_scopes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "code_credential_id"
    t.bigint "scope_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["code_credential_id"], name: "index_approved_scopes_on_code_credential_id"
    t.index ["scope_id"], name: "index_approved_scopes_on_scope_id"
  end

  create_table "clients", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.string "client_id", null: false
    t.string "client_secret", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_clients_on_client_id", unique: true
    t.index ["client_secret"], name: "index_clients_on_client_secret", unique: true
  end

  create_table "code_credentials", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "code", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_code_credentials_on_client_id"
    t.index ["code"], name: "index_code_credentials_on_code", unique: true
  end

  create_table "redirect_uris", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "uri", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_redirect_uris_on_client_id"
  end

  create_table "scopes", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8mb4", force: :cascade do |t|
    t.bigint "client_id", null: false
    t.string "name", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["client_id"], name: "index_scopes_on_client_id"
  end

  add_foreign_key "approved_scopes", "code_credentials"
  add_foreign_key "approved_scopes", "scopes"
  add_foreign_key "code_credentials", "clients"
  add_foreign_key "redirect_uris", "clients"
  add_foreign_key "scopes", "clients"
end
