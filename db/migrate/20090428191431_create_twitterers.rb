class CreateTwitterers < ActiveRecord::Migration
  def self.up
    create_table :twitterers do |t|
      t.text :username, :null => false
      t.text :full_name, :null => false
      t.text :picture_url, :null => false
      t.timestamps
    end
    
    add_index :twitterers, :username, :unique => true
  end

  def self.down
    drop_table :twitterers
  end
end
