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

ActiveRecord::Schema.define(version: 20150109175955) do

  create_table "last_fetched_favorites", force: :cascade do |t|
    t.integer "favorite_id"
    t.integer "user_id"
    t.boolean "last_favorite", default: false
  end

  add_index "last_fetched_favorites", ["user_id"], name: "index_last_fetched_favorites_on_user_id"

  create_table "users", force: :cascade do |t|
    t.integer "twitter_id"
    t.string  "twitter_handle"
    t.string  "access_token"
    t.string  "access_token_secret"
    t.integer "initial_favorites_count"
  end

  add_index "users", ["twitter_id"], name: "index_users_on_twitter_id"

end
