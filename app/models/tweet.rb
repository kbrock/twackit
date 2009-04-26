class Tweet < ActiveRecord::Base
  HASHTAGS_RE = /#\S+\b/         # a pound-sign followed by one or more non-space characters to word boundary
  VALUE_RE = /[-+]?\d[\d\.,]*/   # an optionally signed digit followed by zero or more digits, decimal points, or commas

  # TODO Switch to has_many :through so we have canonical, reusable hashtags? 
  # This would save storage space and  make it easier to compare data between 
  # users with same hashtag.
  has_many :hashtags, :dependent => :destroy

  validates_presence_of :status_id, :status_at, :from_user, :status, :data
  # validates_associated :hashtags
  
  before_validation_on_create :parse_status
  after_create :create_hashtags

  validates_uniqueness_of :status_id
  
  
  named_scope :for_report, lambda { |twitter_user, hashtag|
      { 
        :joins => :hashtags, 
        :conditions => ["from_user=? and hashtags.value=?", twitter_user, hashtag],
        :order => 'status_at desc' 
      }
    }


  class << self
    # Find the latest (most recent) Twitter status ID that we've fetched.
    def latest_id
      first(:order => 'status_id desc').status_id rescue nil
    end

    def report(*options)
      Report.new *options
    end

    def build_for_status(status)
      new(:status_id => status.id,
          :status_at => status.created_at,
          :from_user => status.from_user,
          :status => status.text,
          :language => status.iso_language_code)
    end
  
    def build_for_retro_status(status)
      tweet = build_for_status(status)

      # custom parsing for pre-existing tweets
      content = tweet.status.dup
      values = content.scan(Tweet::VALUE_RE)
      tweet.data = values.first if values.any?

      # remove hash tags
      content.gsub! Tweet::HASHTAGS_RE, ''

      # remove the *first* occurence of data value
      content.sub! Regexp.new(tweet.data), '' unless tweet.data.blank?

      # truncate contiguous whitespace characters to single space
      content.gsub! /\s{2,}/, ' '

      # strip leading ': '
      content.gsub! /^: /, ''
      
      # whatever is left is the note
      tweet.note = content.strip

      # bypass automatic, default parsing algorithm
      tweet.processed = true
      
      tweet
    end
  end # class methods 
  
  
  def value
    # TODO handle more complex data types, time durations, multiple values, etc?
    data.to_f
  end
  
  protected
  
    # Parses a status in the form:
    # @twackit 197.5 #weight
    # @twackit -11,057.23 #net-worth I be broke
    def parse_status
      return if self.processed?

      # TODO handle multiple values
      values = self.status.scan(VALUE_RE)
      self.data = values.first if values.any?
      
      # remove @recipient
      content = self.status.gsub /#{AT_TWITTER_ID}\b/, ''

      # remove hash tags
      content.gsub! HASHTAGS_RE, ''

      # remove the *first* occurence of data value
      content.sub! Regexp.new(self.data), '' unless self.data.blank?
      
      # truncate contiguous whitespace characters to single space
      content.gsub! /\s{2,}/, ' '
      
      # whatever is left is the note
      self.note = content.strip

      self.processed = true
    end

    # after_create
    def create_hashtags
      self.status.scan(HASHTAGS_RE).each do |v|
        self.hashtags.create!(:value => v.delete('#'))
      end
    end
end
