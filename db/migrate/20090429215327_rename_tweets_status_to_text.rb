class RenameTweetsStatusToText < ActiveRecord::Migration
  def self.up
    rename_column :tweets, :status, :status_text
  end

  def self.down
    rename_column :tweets, :status_text, :status
  end
end
