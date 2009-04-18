class CreateTweets < ActiveRecord::Migration
  def self.up
    create_table :tweets do |t|
      t.integer   "status_id", :null => false
      t.datetime  "status_at", :null => false
      t.text      "from_user", :null => false
      t.text      "status", :null => false
      t.text      "language", :null => true
      t.boolean   "processed", :default => false, :null => false

      t.text      "data", :null => false
      t.text      "note", :null => true

      t.timestamps
    end
    
    add_index :tweets, :status_id, :unique => true
    add_index :tweets, :processed
    
    
    create_table :hashtags do |t|
      t.integer   "tweet_id", :null => false
      t.text      "value", :null => false
    end
    
    add_index :hashtags, :tweet_id    
  end

  def self.down
    drop_table :hashtags
    drop_table :tweets
  end
end
