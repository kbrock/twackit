module ReportHelper
  def chart(report)
    tweets = report.tweets
    
    timestamps = tweets.map { |t| t.status_at }
    x_labels = timestamps.map { |ts| ts.strftime("%b %d %y") }    
    start_date = timestamps.min.to_date
    end_date = timestamps.max.to_date

    values = report.values
    min = values.min
    max = values.max
    values = values.map { |v| v - min }
    
    chart = GoogleChart::LineChart.new("720x300", nil, false)
    chart.axis :x, :range => [0, end_date - start_date], :alignment => :center, :labels => x_labels
    chart.axis :y, :range => [min, max], :color => 'ff0000', :alignment => :center

    chart.data_encoding = :simple
    chart.data report.title, values, '6699ff'

    chart.show_legend = false
    chart.line_style 0, :line_thickness => 5
    
    image_tag(chart.to_url, :alt => 'Chart...')
  end
  
  def tweet_calendar(date)
    tweets_by_date = @report.tweets_by_date
    
    calendar(:year => date.year, :month => date.month, :show_today => true, :abbrev => (0..0)) do |d|
      tweets = tweets_by_date[d]
      values = '<ul class="values"><li>' + tweets.map { |t| link_to_tweet(t) }.join('</li><li>') + '</ul>' unless tweets.blank?
      ["<span>#{d.mday}</span>#{values}"]
    end
  end
  
  def link_to_tweet(t)
    link_to t.value, url_for_status(t), :popup => true
  end
end
