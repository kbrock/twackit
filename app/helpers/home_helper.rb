module HomeHelper
  def status_text_with_report_links(tweet)
    text = tweet.status_text.dup
    if tweet.twitterer
      tweet.hashtags.map(&:value).each do |hashtag|
        link = link_to "##{hashtag}", report_path(:twitterer => tweet.twitterer.username, :hashtag => hashtag)
        text.gsub! "##{hashtag}", link
        text
      end
    end
    text.html_safe
  end
  
end
