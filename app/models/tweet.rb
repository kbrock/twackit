class Tweet < ActiveRecord::Base
  HASHTAGS_RE = /\#\S*/

  # TODO Switch to has_many :through so we have canonical, reusable hashtags? 
  # This would save storage space and  make it easier to compare data between 
  # users with same hashtag.
  has_many :hashtags, :dependent => :destroy

  validates_presence_of :status_id, :status_at, :from_user, :status, :data
  # validates_associated :hashtags
  
  before_validation_on_create :parse_status
  after_create :create_hashtags
  
  
  named_scope :for_report, lambda { |twitter_user, hashtag|
      { :joins => :hashtags, :conditions => ["from_user=? and hashtags.value=?", twitter_user, hashtag] }
    }
  
  
  def self.build_for_status(status)
    new(:status_id => status.id,
        :status_at => status.created_at,
        :from_user => v.from_user,
        :status => status.text,
        :language => status.iso_language_code)
  end
  
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
