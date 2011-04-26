class StandardizeHashtags < ActiveRecord::Migration
  def self.up
    create_table :tweet_tags do |t|
      t.integer :tweet_id, :null => false
      t.integer :hashtag_id, :null => false
      t.timestamps
    end

    add_index :tweet_tags, :tweet_id
    add_index :tweet_tags, :hashtag_id

    execute %{
      insert into tweet_tags (tweet_id, hashtag_id)
        select tweet_id, ht2.id
        from hashtags ht1
        join (
          select min(id) as id, value as value
          from hashtags
          group by value
        ) as ht2 on ht2.value = ht1.value
    }

    remove_column :hashtags, :tweet_id

    #remove duplicates
    # join may work better on postgres, but fails in sqlite
    execute %{
      delete from hashtags
      where id <> (select min(id) from hashtags ht2 where ht2.value = hashtags.value)
    }
  end

  def self.down
    add_column :hashtags, :tweet_id, :integer, :null => false
    add_index :hashtags, :tweet_id
    drop_table :tweet_tags
  end
end