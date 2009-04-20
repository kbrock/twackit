class Report
  attr_reader :tweets, :twitter_username, :hashtag, :title, :values, 
      :full_name, :picture_url  
  
  def initialize(attribs)
    @hashtag = attribs[:hashtag]
    @twitter_username = attribs[:twitter_username]
    @title = attribs[:title] ||= attribs[:hashtag].titleize

    @tweets = Tweet.for_report(self.twitter_username, self.hashtag)
    @values = self.tweets.map { |t| t.value }

    # TODO Using this to fetch things from the API like photo URL and full name. Cache this stuff?
    twitter_user = Twitter.user(@twitter_username)
    if twitter_user
      @full_name = twitter_user.name
      @picture_url = twitter_user.profile_image_url
    else
      @full_name = @twitter_username
      @picture_url = nil
    end    
  end  
  
  # Returns data in a structure consumable by a Google Visualization 
  # DataTable. The format is described at http://code.google.com/apis/visualization/documentation/reference.html#DataTable
  def visualization_data
    rows = []
    cols = [
        { :id => 'timestamp', label => 'Date/time', type => 'datetime' },
        { :id => 'value', :label => 'Value', :type => 'number' },
        { :id => 'note', :label => 'Note', :type => 'string' }
        ]
    
    tweets.each do |tweet|
      row = [
          { :v => tweet.status_at },
          { :v => tweet.data },
          { :v => tweet.note },
          ]
      rows << { :c => row }
    end
    
    return { :cols => cols, :rows => rows }
  end
  
  def picture_description
    "#{twitter_username}'s Twitter profile picture"
  end
  
  def tweets_by_date
    @tweets_by_date ||= @tweets.group_by { |t| t.status_at.to_date }
  end
  
  def stats
    return @stats if @stats
    
    if self.values.blank?
      @stats = {}
      return @stats
    end
    
    latest_value = self.values.last
    first_value = self.values.first
    
    @stats = {
      :amount_change => latest_value - first_value,
      :percent_change => (latest_value - first_value)*100/first_value,
      :min => self.values.min,
      :max => self.values.max,
      :avg => self.values.sum/self.values.size
    }
  end
end
