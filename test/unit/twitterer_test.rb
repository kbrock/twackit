require File.dirname(__FILE__) + '/../test_helper'
require 'ostruct'

class TwittererTest < ActiveSupport::TestCase
  setup :stub_twitter_user
  
  test "tweets" do
    twitterer = Factory :twitterer, :username => 'bob'
    Factory :tweet, :from_user => 'bob', :status_text => '@twackit 100 #expenses #lunch'
    Factory :tweet, :from_user => 'bob', :status_text => '@twackit 1.25 #expenses #tolls'
    Factory :tweet, :from_user => 'bob', :status_text => '@twackit 35 #mpg'

    assert exp_tag = Hashtag.find_by_value('expenses')
    assert tolls_tag = Hashtag.find_by_value('tolls')

    assert_equal ['expenses','lunch','tolls','mpg'].sort, Hashtag.all.map(&:value).sort

    assert_equal 2, exp_tag.tweets.size
    assert_equal 1, tolls_tag.tweets.size
  end
  
  test "stale?" do
    twitterer = Factory.build :twitterer, :username => 'bob'
    assert twitterer.stale?

    twitterer.save!
    assert !twitterer.stale?

    twitterer.updated_at = 1.day.ago
    assert !twitterer.stale?, "only consider new records stale for now, avoiding too many API queries"
  end
  
  test "with_username creates new record for unknown username" do
    assert_equal 0, Twitterer.count
    twitterer = Twitterer.with_username('doctorzaius')

    assert_not_nil twitterer
    assert_equal 1, Twitterer.count
    assert_equal 'doctorzaius', twitterer.username
    assert_equal 'Doctor Z', twitterer.full_name
    assert_equal 'zaius.jpg', twitterer.picture_url
    assert !twitterer.stale?
  end

  test "with_username returns existing record for username" do
    twitterer = Factory :twitterer, :username => 'bob', :updated_at => 0.9.days.ago
    assert !twitterer.stale?, 'because updated_at less than a day ago'
    found = Twitterer.with_username 'bob'
    assert_equal twitterer, found
    assert_equal twitterer.updated_at.to_s, found.updated_at.to_s
    assert !twitterer.stale?
  end
  
  # test "with_username for stale record updates values" do
  #   twitterer = Factory :twitterer, 
  #       :username => 'doctorzaius', :full_name => 'Old', :updated_at => 1.1.days.ago
  #   assert twitterer.stale?, 'because updated_at more than a day ago'
  #   found = Twitterer.with_username 'doctorzaius'
  #   assert_equal twitterer, found
  #   assert_equal 'Doctor Z', found.full_name
  #   assert found.updated_at - twitterer.updated_at > 1.day
  #   assert !found.stale?
  # end

  test "with_username given invalid username raises" do
    Twitterer.any_instance.stubs(:twitter_user).returns(nil)
    assert_raise(InvalidTwitterUsername) do
      Twitterer.with_username 'bogus'
    end
  end

  protected
  
    def stub_twitter_user
      # stub the method that normally calls the twitter api
      mock_twitter_user = OpenStruct.new :name => 'Doctor Z', :profile_image_url => 'zaius.jpg'
      Twitterer.any_instance.stubs(:twitter_user).returns(mock_twitter_user)
    end
    
end
