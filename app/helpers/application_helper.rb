# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  # Options hash can specify a size: m (micro), n (normal), b (big), or o (original)
  # See http://tweetimag.es/
  def twitter_profile_image_url(screen_name, options={})
    options[:size] ||= 'n'
    "http://img.tweetimag.es/i/#{screen_name}_#{options[:size]}"
  end

  def title(t)
    content_for :page_title, t
  end
  
  def enable_analytics?
    Rails.env.production? && ENV['GOOGLE_ANALYTICS_ACCOUNT_ID'].present?
  end
  
  def tweet_this_page(locals={})
    locals[:status] ||= 'Whatever it is, track it with Twackit! http://www.twackit.com'
    render :partial => 'layouts/tweet_this_page', :locals => locals
  end
  
  def random_tweet_prompt
    [
    'Make the bird happy.',
    'Make birdy happy.',
    'The bird is watching.',
    'Join the club.',
    'Love the bird.',
    'Be excellent.',
    'Be cool.',
    'Spread the love.',
    'Spread the seed.',
    'Tell your friends.',
    'Birdy loves you.',
    'Impress the bird.'
    ].sample
  end
  
  def feedback_page
    { :href => 'http://twackit.uservoice.com' }
  end
  
  def url_for_status(tweet)
    "http://twitter.com/#{tweet.from_user}/status/#{tweet.status_id}"
  end
  
  def smart_timestamp(time)
    if time > 2.days.ago
      time_ago_in_words(time) + ' ago'
    else
      time.to_s(:long_us)
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
