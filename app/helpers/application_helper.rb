# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def title(t)
    content_for :page_title, t
  end
  
  def url_for_status(tweet)
    "http://twitter.com/#{tweet.from_user}/status/#{tweet.status_id}"
  end
  
  def smart_timestamp(time)
    if time > 2.days.ago
      time_ago_in_words(time) + ' ago'
    else
      time.to_s(:long)
    end
  end
  
  def javascript(*files)
    @javascripts ||= []
    @javascripts += files.map do |f|
      f.to_s =~ /http/ ? f : "/javascripts/#{f.to_s}.js"
    end
  end
  
  def style(*files)
    @styles ||= []
    @styles += files.map do |f|
      "/stylesheets/#{f.to_s}.css"
    end
  end
end
