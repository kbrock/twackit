require File.dirname(__FILE__) + '/../test_helper'

class TweetTest < ActiveSupport::TestCase
  test "build_for_status and save" do
    assert_tweet('@twackit 175 #weight #tag2 this is a note',
      :note => 'this is a note',
      :data => '175',
      :hashtag_value => ['tag2','weight']
    )
  end
  
  test "build_for_status with value after hashtag" do
    assert_tweet('@twackit #weight 175 this is a note',
      :note => 'this is a note',
      :data => '175',
      :hashtag_value => ['weight']
    )
  end
  
  test "build_for_status with date" do
    assert_tweet('@twackit 7.5 this is a note 5/30/1977 #weight',
      :data => '7.5',
      :note => 'this is a note',
      :hashtag_value => ['weight'],
      :status_at => Date.new(1977, 5, 30)
    )
  end
  
  test "with spaces" do
    assert_tweet('@twackit  180            #calories  Banana Pudding Ice Cream',
      :note => 'Banana Pudding Ice Cream',
      :data => '180',
      :hashtag_value => ['calories']
    )
  end

  def assert_tweet(text, expected)
    expected = {:from_user => 'doctorzaius', :language => 'en'}.merge(expected)

    tweet = Tweet.build_for_status Factory(:status, :text => text)
    tweet.save!

    assert tweet.processed?
    assert_equal expected[:from_user], tweet.from_user
    assert_equal expected[:language], tweet.language

    # this stuff gets parsed from status_text
    assert_equal expected[:note], tweet.note
    assert_equal expected[:data], tweet.data
    assert_equal expected[:hashtag_value].sort, tweet.hashtags.map(&:value).sort
    assert_equal expected[:status_at], tweet.status_at.to_date if expected[:status_at]
  end
end
