class Twitterer < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  validates_presence_of :username
  validates_presence_of :full_name
  
  validates_uniqueness_of :username
  
  class << self
    def with_username(username)
      twitterer = find_by_username(username) 
      twitterer ||= Twitterer.new(:username => username)
      
      twitterer.update_values! if twitterer.stale?

      twitterer
    end
  end

  def stale?
    new_record? || updated_at < 1.day.ago
  end
  
  def update_values!
    if twitter_user
      self.full_name = twitter_user.name
      self.picture_url = twitter_user.profile_image_url
    else
      self.full_name ||= self.username
    end
    
    self.save!
  end

  def tweets(hashtag)
    Tweet.for_report(self.username, hashtag)
  end
  
  protected
  
    # Use the Twitter API to fetch a representation of the Twitter user, which
    # includes attributes like #name and #profile_image_url.
    def twitter_user
      twitter_user = Twitter.user(self.username) rescue nil
    end
    memoize :twitter_user
end
