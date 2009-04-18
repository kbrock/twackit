class Report
  attr_reader :tweets, :twitter_username, :hashtag, :title, :values
  
  def initialize(attribs)
    @hashtag = attribs[:hashtag]
    @twitter_username = attribs[:twitter_username]
    @title = attribs[:title] ||= attribs[:hashtag].titleize

    @tweets = Tweet.for_report(self.twitter_username, self.hashtag)
    @values = self.tweets.map { |t| t.value }
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