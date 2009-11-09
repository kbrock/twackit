class InvalidTwitterUsername < StandardError; end

class Twitterer < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  validates_presence_of :username
  validates_presence_of :full_name
  
  validates_uniqueness_of :username
  
  class << self
    def with_username username
      twitterer = find_by_username username
      twitterer ||= Twitterer.new :username => username
      
      twitterer.update_values! if twitterer.stale?

      twitterer
    end
    
    # def report options
    #   options[:twitterer] = username
    #   Report.new options
    # end    
  end

  def stale?
    new_record? || updated_at < 1.day.ago
  end
  
  def update_values!
    twitter_user = self.twitter_user
    raise InvalidTwitterUsername.new(self.username) if twitter_user.nil?

    self.full_name = twitter_user.name
    self.picture_url = twitter_user.profile_image_url
    
    self.save!
  end

  def tweets hashtag
    Tweet.for_report self.username, hashtag
  end
  
  def profile_url
    "http://twitter.com/#{username}"
  end
  
  protected
  
    # Use the Twitter API to fetch a representation of the Twitter user, which
    # includes attributes like #name and #profile_image_url.
    def twitter_user
      u = Twitter.user(self.username) #rescue nil
      return u unless u && u.error?
    end
    memoize :twitter_user
end
