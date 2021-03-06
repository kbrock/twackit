module ReportHelper  
  def tweet_calendar(date)
    tweets_by_date = @report.tweets_by_date
    
    calendar(:year => date.year, :month => date.month, :show_today => true, :abbrev => (0..0)) do |d|
      tweets = tweets_by_date[d]
      values = '<ul class="values"><li>' + tweets.map { |t| link_to_tweet(t) }.join('</li><li>') + '</li></ul>' unless tweets.blank?
      ["<span>#{d.mday}</span>#{values}"]
    end.html_safe
  end
  
  def link_to_tweet(t)
    link_to t.value, url_for_status(t), 'data-popup' => 'true'
  end
  
  def searching_indicator_options
    { :style => ('display: none' unless @background_search) } 
  end
  
  def updated_timestamp_options
    { :style => ('display: none;' if @background_search) } 
  end
end
