class ChangeTweetsStatusIdToText < ActiveRecord::Migration
  def self.up
    change_column :tweets, :status_id, :text
  end

  def self.down
    change_column :tweets, :status_id, :integer
  end
end
