# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  
  def url_for_status(tweet)
    "http://twitter.com/#{tweet.from_user}/status/#{tweet.status_id}"
  end
end
