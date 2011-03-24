require File.dirname(__FILE__) + '/../test_helper'

class TweetTest < ActiveSupport::TestCase
  test "build_for_status and save" do
    status = Factory(:status, :text => '@twackit 175 #weight #tag2 this is a note')
        
    tweet = Tweet.build_for_status status    
    tweet.save!
    
    assert tweet.processed?
    assert_equal 'doctorzaius', tweet.from_user
    assert_equal 'en', tweet.language
    
    # this stuff gets parsed from status_text
    assert_equal 'this is a note', tweet.note
    assert_equal '175', tweet.data
    assert_equal ['tag2', 'weight'], tweet.hashtags.map(&:value).sort
  end
  
  test "build_for_status with value after hashtag" do
    status = Factory(:status, :text => '@twackit #weight 175 this is a note')
        
    tweet = Tweet.build_for_status status    
    tweet.save!
    
    assert tweet.processed?
    assert_equal 'doctorzaius', tweet.from_user
    assert_equal 'en', tweet.language
    
    # this stuff gets parsed from status_text
    assert_equal 'this is a note', tweet.note
    assert_equal '175', tweet.data
    assert_equal ['weight'], tweet.hashtags.map(&:value)
  end
  
  test "build_for_status with date" do
    status = Factory(:status, :text => '@twackit 7.5 this is a note 5/30/1977 #weight')
        
    tweet = Tweet.build_for_status status
    tweet.save!
    
    assert tweet.processed?
    assert_equal 'doctorzaius', tweet.from_user
    assert_equal 'en', tweet.language
    
    # this stuff gets parsed from status_text
    assert_equal 'this is a note', tweet.note
    assert_equal '7.5', tweet.data
    assert_equal ['weight'], tweet.hashtags.map(&:value)
    assert_equal Date.new(1977, 5, 30), tweet.status_at.to_date
  end
  
  test "with spaces" do
    status = Factory(:status, :text => '@twackit  180            #calories  Banana Pudding Ice Cream')

    tweet = Tweet.build_for_status status    
    tweet.save!

    assert tweet.processed?
    assert_equal 'doctorzaius', tweet.from_user
    assert_equal 'en', tweet.language

    # this stuff gets parsed from status_text
    assert_equal 'Banana Pudding Ice Cream', tweet.note
    assert_equal '180', tweet.data
    assert_equal ['calories'], tweet.hashtags.map(&:value)
  end
end
