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

ActiveRecord::Schema.define(version: 2022_03_26_184701) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "api_calls", force: :cascade do |t|
    t.integer "service"
    t.string "url"
    t.jsonb "request"
    t.jsonb "response"
    t.integer "status_code"
    t.string "error"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "cloud_files", force: :cascade do |t|
    t.string "remote_id"
    t.string "filename"
    t.integer "status"
    t.string "original_link"
    t.boolean "directory"
    t.datetime "remote_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.integer "content_type"
    t.string "server"
    t.bigint "remote_amount", default: 0
    t.bigint "file_size"
    t.index ["remote_id"], name: "index_cloud_files_on_remote_id", unique: true
  end

  create_table "paths", force: :cascade do |t|
    t.bigint "cloud_file_id"
    t.string "path"
    t.integer "status"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "url"
    t.bigint "amount", default: 0
    t.bigint "size"
    t.index ["cloud_file_id"], name: "index_paths_on_cloud_file_id"
  end

  create_table "sync_errors", force: :cascade do |t|
    t.string "failable_type", null: false
    t.bigint "failable_id", null: false
    t.string "message", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["failable_type", "failable_id"], name: "index_sync_errors_on_failable"
  end

end
