# This file is auto-generated from the current state of the database. Instead of editing this file, 
# please use the migrations feature of Active Record to incrementally modify your database, and
# then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your database schema. If you need
# to create the application database on another system, you should be using db:schema:load, not running
# all the migrations from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20090428191431) do

  create_table "hashtags", :force => true do |t|
    t.integer "tweet_id", :null => false
    t.text    "value",    :null => false
  end

  add_index "hashtags", ["tweet_id"], :name => "index_hashtags_on_tweet_id"

  create_table "imports", :force => true do |t|
    t.integer  "tweets"
    t.integer  "distinct_users"
    t.integer  "errs"
    t.float    "duration"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "page_requests", :force => true do |t|
    t.text     "url"
    t.text     "method"
    t.text     "cookies"
    t.text     "user_agent"
    t.text     "remote_ip"
    t.text     "session_id"
    t.text     "referrer"
    t.boolean  "xhr"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "tweets", :force => true do |t|
    t.integer  "status_id",                     :null => false
    t.datetime "status_at",                     :null => false
    t.text     "from_user",                     :null => false
    t.text     "status",                        :null => false
    t.text     "language"
    t.boolean  "processed",  :default => false, :null => false
    t.text     "data",                          :null => false
    t.text     "note"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "tweets", ["processed"], :name => "index_tweets_on_processed"
  add_index "tweets", ["status_id"], :name => "index_tweets_on_status_id", :unique => true

  create_table "twitterers", :force => true do |t|
    t.text     "username",    :null => false
    t.text     "full_name",   :null => false
    t.text     "picture_url", :null => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "twitterers", ["username"], :name => "index_twitterers_on_username", :unique => true

end
