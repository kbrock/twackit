class Hashtag < ActiveRecord::Base

  belongs_to :tweet

  validates_presence_of :tweet_id
  validates_presence_of :value

end