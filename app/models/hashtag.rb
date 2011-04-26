class Hashtag < ActiveRecord::Base

  has_many :tweet_tags
  has_many :tweets, :through => :tweet_tags
  validates_presence_of :value
  validates_presence_of :username

  def to_param
    value
  end

  def self.fetch(username,value)
    find_by_username_and_value(username,value)
  end

  def self.fetch_or_create(username, value)
    Hashtag.find_or_create_by_username_and_value(username, value)
  end
end