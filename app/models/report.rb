class Report
  extend ActiveSupport::Memoizable
  
  attr_reader :tag, :title
  def initialize(attribs)
    if attribs[:tag]
      @tag = attribs[:tag]
    else
      @tag = Hashtag.fetch(attribs[:twitterer], attribs[:hashtag])
    end

    @title = attribs[:title] || @tag.value.titleize
  end  

  def hashtag
    @tag.value
  end

  def username
    @tag.username
  end

  def twitterer
    @tag.twitterer
  end

  def tweets
    @tweets ||= @tag ? @tag.tweets.recent_first : []
  end

  def tweets?
    tweets.any?
  end

  def last_updated?
    tweets.last.try(:status_at)
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
    "#{twitterer.full_name}'s Twitter profile picture"
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

  def values
    tweets.map { |t| t.value }
  end
  memoize :values
end
