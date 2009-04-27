class Report
  extend ActiveSupport::Memoizable
  
  attr_reader :tweets, :twitterer, :hashtag, :title, :values, 
      :full_name, :picture_url
  
  def initialize(attribs)
    @hashtag = attribs[:hashtag]
    @twitterer = attribs[:twitterer]
    @title = attribs[:title] ||= attribs[:hashtag].titleize

    @tweets = Tweet.for_report(self.twitterer, self.hashtag)
    @values = self.tweets.map { |t| t.value }

    # TODO Using this to fetch things from the API like photo URL and full name. 
    # Cache this stuff in a Twitterer model that is periodically updated. Or
    # memcached if/when available.
    twitter_user = Twitter.user(@twitterer) rescue nil
    if twitter_user
      @full_name = twitter_user.name
      @picture_url = twitter_user.profile_image_url
    else
      @full_name = @twitterer
      @picture_url = nil
    end
  end  
  
  # Returns data in a structure consumable by a Google Visualization DataTable. 
  # The format is described at http://code.google.com/apis/visualization/documentation/reference.html#DataTable
  def visualization_data
    cols = [
        { :id => 'date', :label => 'Date', :type => 'date' },
        { :id => 'value', :label => hashtag.titleize, :type => 'number' },
        { :id => 'note', :label => 'Note', :type => 'string' }
        ]
    
    rows = tweets.map do |tweet|
      { 
        :c => [
          { :v => tweet.status_at.to_date }, #, :f => tweet.status_at.to_s(:long_us) },
          { :v => tweet.data.to_f },
          { :v => tweet.note }
          ]
      }
    end
     
    { :cols => cols, :rows => rows }
  end
  
  def picture_description
    "#{twitterer}'s Twitter profile picture"
  end
  
  def tweets_by_date
    @tweets.group_by { |t| t.status_at.to_date }
  end
  memoize :tweets_by_date
  
  def stats
    return {} if self.values.blank?
    
    latest_value = values.first
    first_value = values.last
    
    {
      :amount_change => latest_value - first_value,
      :percent_change => (latest_value - first_value)*100/first_value,
      :min => self.values.min,
      :max => self.values.max,
      :avg => self.values.sum/self.values.size
    }
  end
  memoize :stats

end
