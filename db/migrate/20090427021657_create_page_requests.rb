class CreatePageRequests < ActiveRecord::Migration
  def self.up
    create_table :page_requests do |t|
      t.text :url
      t.text :method
      t.text :cookies
      t.text :user_agent
      t.text :remote_ip
      t.text :session_id
      t.text :referrer
      t.boolean :xhr

      t.timestamps
    end
  end

  def self.down
    drop_table :page_requests
  end
end
