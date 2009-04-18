class Tweet < ActiveRecord::Base
  HASHTAGS_RE = /\#\S*/

  has_many :hashtags, :dependent => :destroy

  validates_presence_of :status_id, :status_at, :from_user, :status, :data
  # validates_associated :hashtags
  
  before_validation_on_create :parse_status
  after_create :create_hashtags
  
  
  named_scope :for_report, lambda { |twitter_user, hashtag|
      { :joins => :hashtags, :conditions => ["from_user=? and hashtags.value=?", twitter_user, hashtag] }
    }
  
  
  # Find the latest (most recent) Twitter status ID that we've fetched.
  def self.latest_id
    first(:order => 'status_id desc').status_id rescue nil
  end
  
  def self.report(*options)
    Report.new *options
  end
  
  def value
    # TODO handle more complex data types, time durations, multiple values, etc?
    data.to_f
  end
  
  protected
  
    def parse_status
      return if self.processed?
  
      # remove @recipient and hash tags
      content = self.status.gsub(/^#{AT_TWITTER_ID}/, '').split(HASHTAGS_RE).join.split.join(' ')

      segments = content.split
      self.data = segments.shift # extract first segment
      self.note = segments.join(' ')

      self.processed = true
    end

    def create_hashtags
      self.status.scan(HASHTAGS_RE).each do |v|
        self.hashtags.create!(:value => v.delete('#'))
      end
    end
end
