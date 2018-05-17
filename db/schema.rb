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

ActiveRecord::Schema.define(version: 20180517115933) do

  create_table "collections", force: :cascade do |t|
    t.string "title"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_collections_on_user_id"
  end

  create_table "collections_notes", id: false, force: :cascade do |t|
    t.integer "collection_id", null: false
    t.integer "note_id", null: false
    t.index ["collection_id", "note_id"], name: "index_collections_notes_on_collection_id_and_note_id"
    t.index ["note_id", "collection_id"], name: "index_collections_notes_on_note_id_and_collection_id"
  end

  create_table "friendships", force: :cascade do |t|
    t.string "friendable_type"
    t.integer "friendable_id"
    t.integer "friend_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "blocker_id"
    t.integer "status"
  end

  create_table "notes", force: :cascade do |t|
    t.integer "user_id"
    t.string "text"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["user_id"], name: "index_notes_on_user_id"
  end

  create_table "sharedNote", force: :cascade do |t|
    t.integer "user_id"
    t.integer "sharedUser_id"
    t.integer "note_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id"], name: "index_sharedNote_on_note_id"
    t.index ["sharedUser_id"], name: "index_sharedNote_on_sharedUser_id"
    t.index ["user_id"], name: "index_sharedNote_on_user_id"
    t.index [nil], name: "index_sharedNote_on_note"
    t.index [nil], name: "index_sharedNote_on_sharedUser"
    t.index [nil], name: "index_sharedNote_on_user"
  end

  create_table "users", force: :cascade do |t|
    t.string "username"
    t.string "password"
    t.string "role", default: "User"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
