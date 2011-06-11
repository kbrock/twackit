# Logs some stats about an import from Twitter.
class Import < ActiveRecord::Base
  validates_presence_of :tweets
  validates_presence_of :distinct_users
  validates_presence_of :errs
  validates_presence_of :duration

  named_scope :by_most_recent, :order => 'created_at desc'

  def self.stale?
    most_recent = by_most_recent.first
    most_recent.nil? || most_recent.created_at < 60.seconds.ago
  end
end