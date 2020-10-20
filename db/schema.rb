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

ActiveRecord::Schema.define(version: 2020_09_18_102908) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "albums", force: :cascade do |t|
    t.string "name"
    t.string "artist"
    t.bigint "user_id"
    t.string "color"
    t.index ["user_id"], name: "index_albums_on_user_id"
  end

  create_table "albums_tags", id: false, force: :cascade do |t|
    t.bigint "album_id"
    t.bigint "tag_id"
    t.index ["album_id"], name: "index_albums_tags_on_album_id"
    t.index ["tag_id"], name: "index_albums_tags_on_tag_id"
  end

  create_table "jwt_blacklist", force: :cascade do |t|
    t.string "jti", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti"
  end

  create_table "song_sources", force: :cascade do |t|
    t.bigint "song_id"
    t.string "source"
    t.string "code"
    t.index ["song_id"], name: "index_song_sources_on_song_id"
  end

  create_table "songs", force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.string "color"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "album_id"
    t.index ["album_id"], name: "index_songs_on_album_id"
    t.index ["user_id"], name: "index_songs_on_user_id"
  end

  create_table "songs_tags", id: false, force: :cascade do |t|
    t.bigint "song_id"
    t.bigint "tag_id"
    t.index ["song_id"], name: "index_songs_tags_on_song_id"
    t.index ["tag_id"], name: "index_songs_tags_on_tag_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.index ["user_id"], name: "index_tags_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "name"
    t.string "spotify_token"
    t.string "spotify_refresh_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "albums", "users"
  add_foreign_key "song_sources", "songs"
  add_foreign_key "songs", "albums"
  add_foreign_key "tags", "users"
end
