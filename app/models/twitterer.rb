class InvalidTwitterUsername < StandardError; end

class Twitterer < ActiveRecord::Base
  extend ActiveSupport::Memoizable

  validates_presence_of :username
  validates_presence_of :full_name
  
  validates_uniqueness_of :username

  has_many :hashtags, :primary_key => :username, :foreign_key => :username

  def stale?
    new_record? #|| updated_at < 30.days.ago
  end
  
  def update_values!
    twitter_user = self.twitter_user
    raise InvalidTwitterUsername.new(self.username) if twitter_user.nil?

    self.full_name = twitter_user.name
    self.picture_url = twitter_user.profile_image_url
    
    self.save!
  end

  def profile_url
    "http://twitter.com/#{username}"
  end
  
  def self.with_username username
    twitterer = find_by_username(username) || Twitterer.new(:username => username)
    twitterer.update_values! if twitterer.stale?
    twitterer
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
