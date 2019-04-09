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

ActiveRecord::Schema.define(version: 2019_06_05_231121) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "artist_genres", force: :cascade do |t|
    t.string "name"
    t.bigint "featured_artist_id"
    t.index ["featured_artist_id"], name: "index_artist_genres_on_featured_artist_id"
  end

  create_table "featured_artists", force: :cascade do |t|
    t.string "name"
    t.string "artist_code"
    t.bigint "track_feature_id"
    t.index ["track_feature_id"], name: "index_featured_artists_on_track_feature_id"
  end

  create_table "jwt_blacklist", force: :cascade do |t|
    t.string "jti", null: false
    t.index ["jti"], name: "index_jwt_blacklist_on_jti"
  end

  create_table "library_songs", force: :cascade do |t|
    t.text "color"
    t.bigint "user_id"
    t.bigint "song_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["song_id"], name: "index_library_songs_on_song_id"
    t.index ["user_id"], name: "index_library_songs_on_user_id"
  end

  create_table "library_songs_tags", id: false, force: :cascade do |t|
    t.bigint "library_song_id"
    t.bigint "tag_id"
    t.index ["library_song_id"], name: "index_library_songs_tags_on_library_song_id"
    t.index ["tag_id"], name: "index_library_songs_tags_on_tag_id"
  end

  create_table "played_songs", force: :cascade do |t|
    t.string "spotify_id"
    t.string "artist"
    t.string "name"
    t.integer "popularity"
    t.string "uri"
    t.string "album_cover_64"
    t.string "album_cover_640"
    t.string "album_name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "user_id"
    t.bigint "songs_id"
    t.index ["songs_id"], name: "index_played_songs_on_songs_id"
    t.index ["user_id"], name: "index_played_songs_on_user_id"
  end

  create_table "song_features", force: :cascade do |t|
    t.string "spotify_id"
    t.string "uri"
    t.integer "time_signature"
    t.float "acousticness"
    t.float "danceability"
    t.float "energy"
    t.float "instrumentalness"
    t.float "liveness"
    t.float "loudness"
    t.float "speechiness"
    t.float "valence"
    t.float "tempo"
    t.string "track_href"
    t.string "analysis_url"
    t.integer "popularity"
    t.datetime "release_date"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "isSaved"
  end

  create_table "songs", force: :cascade do |t|
    t.string "name"
    t.string "artist"
    t.string "source"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "task_events", force: :cascade do |t|
    t.bigint "task_id"
    t.integer "time"
    t.boolean "on_time"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["task_id"], name: "index_task_events_on_task_id"
  end

  create_table "tasks", force: :cascade do |t|
    t.bigint "user_id"
    t.string "name"
    t.string "category"
    t.integer "frequency"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "last_time_done"
    t.index ["user_id"], name: "index_tasks_on_user_id"
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

  add_foreign_key "artist_genres", "featured_artists"
  add_foreign_key "featured_artists", "song_features", column: "track_feature_id"
  add_foreign_key "library_songs", "songs"
  add_foreign_key "library_songs", "users"
  add_foreign_key "task_events", "tasks"
  add_foreign_key "tasks", "users"
end
