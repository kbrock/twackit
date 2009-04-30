require 'test_helper'
require 'ostruct'

class TweetTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "build_for_status and save" do
    # mock a status objects returned by the Twitter search API 
    status = OpenStruct.new(
        :created_at => Time.utc(2009, 4, 29, 19, 6, 33),
        :from_user => 'doctorzaius',
        :status_text => '@twackit 175 #weight #tag2 this is a note',
        :iso_language_code => 'en')
        
    tweet = Tweet.build_for_status status    
    tweet.save!
    
    assert tweet.processed?
    assert_equal 'doctorzaius', tweet.from_user
    assert_equal 'en', tweet.language
    assert_equal 'this is a note', tweet.note
    assert_equal '175', tweet.data
    assert_equal ['weight', 'tag2'], tweet.hashtags.map(&:value)
  end
end
