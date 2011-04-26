require File.dirname(__FILE__) + '/../test_helper'

class TweetTest < ActiveSupport::TestCase
  test "build_for_status and save" do
    assert_tweet('@twackit 175 #weight #tag2 this is a note',
      :note => 'this is a note',
      :data => '175',
      :float_data => 175.0,
      :hashtag_value => ['tag2','weight'],
      :tagless? => false
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
    assert_tweet('@twackit 7.5 ate them with milk 5/30/1977 #cookies',
      :data => '7.5',
      :note => 'ate them with milk',
      :hashtag_value => ['cookies'],
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

  test "direct message" do
    assert_tweet('71.6 #weight',
      :data => '71.6',
      :hashtag_value => ['weight']
    )
  end

  test "tweets without tags are marked tagless" do
    assert_tweet('@twackit 33', :tagless? => true)
  end

  test "recent only returns tweets with tags" do
    good1=create_tweet('@twackit 175 #weight')
    good2=create_tweet('@twackit 176 #weight')
    create_tweet('@twackit 33')
    
    assert_equal [good1,good2], Tweet.recent.sort_by {|t| t.float_data}
  end

  # not sure if this is a valid use case
  # test "retweet" do
  #   assert_tweet('RT @joe123: @twackit drank lots of water 71.6 #weight',
  #     :data => '71.6',
  #     :note => 'drank lots of water',
  #     :hashtag_value => ['weight']
  #   )
  # end

  private

  # from_user, language are from the tweet message
  # note, data, hashtag_value status_at are from the message
  def assert_tweet(text, expected)
    expected = {:from_user => 'doctorzaius', :language => 'en'}.merge(expected)

    tweet = create_tweet(text)

    assert tweet.processed?
    assert_equal expected.delete(:status_at), tweet.status_at.to_date if expected[:status_at]

    assert_equal expected[:hashtag_value].sort, tweet.hashtags.map(&:value).sort
    expected.each_pair do |key,value|
      assert_equal value, tweet.send(key)
    end
  end
  
  def create_tweet(text)
    tweet = Tweet.build_for_status Factory(:status, :text => text)
    tweet.save!
    tweet
  end
end
