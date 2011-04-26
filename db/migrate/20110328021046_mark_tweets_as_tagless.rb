class MarkTweetsAsTagless < ActiveRecord::Migration
  def self.up
    add_column :tweets, :tagless, :boolean, :default => false, :null => false
    
    execute %{
      update tweets
      set tagless = true
      where not exists (select 1 from tweet_tags where tweet_id = tweets.id)
    }
  end

  def self.down
    remove_column :tweets, :tagless
  end
end