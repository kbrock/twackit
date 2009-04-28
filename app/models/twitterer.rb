class Twitterer < ActiveRecord::Base
  validates_presence_of :username
  validates_presence_of :full_name
  validates_presence_of :picture_url
  
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
    twitter_user = Twitter.user(self.username) rescue nil
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
end
