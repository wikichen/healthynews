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

ActiveRecord::Schema.define(:version => 20130702023716) do

  create_table "comments", :force => true do |t|
    t.text     "body"
    t.integer  "user_id"
    t.integer  "post_id"
    t.datetime "created_at",                :null => false
    t.datetime "updated_at",                :null => false
    t.integer  "upvotes",    :default => 0, :null => false
    t.integer  "downvotes",  :default => 0, :null => false
  end

  create_table "posts", :force => true do |t|
    t.string   "title",                                                   :default => "",  :null => false
    t.string   "url",                                                     :default => ""
    t.string   "short_id",   :limit => 6,                                 :default => "",  :null => false
    t.integer  "user_id"
    t.datetime "created_at",                                                               :null => false
    t.datetime "updated_at",                                                               :null => false
    t.decimal  "hotness",                 :precision => 20, :scale => 10, :default => 0.0, :null => false
    t.integer  "upvotes",                                                 :default => 0,   :null => false
    t.integer  "downvotes",                                               :default => 0,   :null => false
  end

  add_index "posts", ["hotness"], :name => "index_posts_on_hotness"
  add_index "posts", ["user_id"], :name => "index_posts_on_user_id"

  create_table "users", :force => true do |t|
    t.datetime "created_at",                             :null => false
    t.datetime "updated_at",                             :null => false
    t.string   "email",                  :default => "", :null => false
    t.string   "encrypted_password",     :default => "", :null => false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "username"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["reset_password_token"], :name => "index_users_on_reset_password_token", :unique => true
  add_index "users", ["username"], :name => "index_users_on_username", :unique => true

  create_table "votes", :force => true do |t|
    t.integer  "vote",       :limit => 2, :null => false
    t.integer  "user_id",                 :null => false
    t.integer  "post_id",                 :null => false
    t.integer  "comment_id"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

end
