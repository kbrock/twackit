class Hashtag < ActiveRecord::Base

  attr_accessor :cleaned_up
  has_many :tweet_tags
  has_many :tweets, :through => :tweet_tags
  #belongs_to :twitterer, :foreign_key => :username, :primary_key => :username
  validates_presence_of :value
  validates_presence_of :username

  def to_param
    value
  end

  #the tag/username were cleaned up
  def cleaned_up?
    cleaned_up == true
  end

  def twitterer
    @twitterer ||= Twitterer.with_username self.username
  end

  def tag
    value
  end

  def self.fetch_or_create(username, value)
    find_or_create_by_username_and_value(username, value)
  end

  # used for reporting. don't need to create a tag, but the entity must be represented
  def self.fetch(username, tag)
    raise ArgumentError, 'hashtag must be specified' if username.blank?
    raise ArgumentError, 'twitterer must be specified' if tag.blank?

    u = username.gsub('@', '').strip
    t = tag.gsub('#', '').strip
    cleaned_up=(u != username || t != tag)

    tag=find_by_username_and_value(u,t)||new(:username => u, :value => t, :cleaned_up =>cleaned_up)
    #get this out of here
    raise InvalidTwitterUsername.new(u) if tag.twitterer.nil?
    tag
  end
end