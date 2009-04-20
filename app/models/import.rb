# Logs some stats about an import from Twitter.
class Import < ActiveRecord::Base
  validates_presence_of :tweets
  validates_presence_of :distinct_users
  validates_presence_of :errs
  validates_presence_of :duration
end
