class MarkTweetsAsTagless < ActiveRecord::Migration
  def self.up
    add_column :tweets, :tagless, :boolean, :default => false, :null => false

    # set to true (but using # for sqlite support)
    execute %{
      update tweets
      set tagless = 1
      where not exists (select 1 from tweet_tags where tweet_id = tweets.id)
    }
  end

  def self.down
    remove_column :tweets, :tagless
  end
end