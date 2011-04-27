class Hashtag < ActiveRecord::Base

  has_many :tweet_tags
  has_many :tweets, :through => :tweet_tags
  #belongs_to :twitterer, :foreign_key => :username, :primary_key => :username
  validates_presence_of :value
  validates_presence_of :username

  def to_param
    value
  end

  def twitterer
    @twitterer ||= Twitterer.with_username self.username
  end

  def self.fetch_or_create(username, value)
    find_or_create_by_username_and_value(username, value)
  end

  # used for reporting. don't need to create a tag, but the entity must be represented
  def self.with_name_tag(username, value)
    find_by_username_and_value(username,value)||new(:username => username, :value => value)
  end
end