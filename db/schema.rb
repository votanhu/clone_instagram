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

ActiveRecord::Schema.define(version: 20150809232940) do

  create_table "comments", force: true do |t|
    t.integer  "id_photo"
    t.integer  "id_user"
    t.string   "message"
    t.integer  "is_notified", :default => 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "follows", force: true do |t|
    t.integer  "id_user"
    t.integer  "id_follower"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "hashtags", force: true do |t|
    t.string   "tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photo_hashtags", force: true do |t|
    t.integer  "id_photo"
    t.integer  "id_tag"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", force: true do |t|
    t.integer  "id_user"
    t.string   "name"
    t.string   "url"
    t.string   "exif"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "username"
    t.string   "password"
    t.string   "name"
    t.string   "phone"
    t.string   "website"
    t.string   "email"
    t.integer  "sex"
    t.string   "bio"
    t.integer  "similiar_account_suggestion"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
