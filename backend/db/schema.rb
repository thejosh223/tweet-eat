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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130608105842) do

  create_table "errand_requests", :force => true do |t|
    t.integer  "errand_id"
    t.integer  "user_id"
    t.datetime "deadline"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "errands", :force => true do |t|
    t.integer  "user_id"
    t.string   "title"
    t.text     "body"
    t.decimal  "price"
    t.datetime "deadline"
    t.integer  "errand_request_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
    t.text     "location"
    t.float    "latitude"
    t.float    "longitude"
  end

  create_table "ratings", :force => true do |t|
    t.integer  "for_user_id"
    t.integer  "by_user_id"
    t.integer  "score"
    t.text     "body"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "email"
    t.string   "password_digest"
    t.decimal  "credit"
    t.text     "location"
    t.float    "latitude"
    t.float    "longitude"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "fb_id"
  end

end
