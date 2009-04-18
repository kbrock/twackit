# Uses Twitter gem. http://github.com/jnunemaker/twitter/tree/master
class TwitterImporter

  def self.import!(per_page=100)
    results = []
    since_id = Tweet.latest_id

    Rails.logger.info "Searching for new tweets since #{since_id}"

    # fetch all new tweets
    page = 1
    while true
      Rails.logger.info "Fetching page #{page} (#{per_page} per page)"
      
      # find tweets on this page
      page_results = searcher.since(since_id).per_page(per_page).page(page).fetch.results      
      results += page_results

      # if we didn't get a full page, we're at the end
      break if page_results.size < per_page
      
      page += 1
    end

    Rails.logger.info "Found #{results.size} new tweets"

    # TODO: Fetch direct messages?


    # log new tweets to database
    tweets = Array.new(results.size)
    results.each_with_index do |r, i|
      tweet = Tweet.new(
          :status_id => r.id,
          :status_at => r.created_at,
          :from_user => r.from_user,
          :status => r.text,
          :language => r.iso_language_code)

      # Don't fail too noisily... we want to continue processing!
      if tweet.save!
        tweets[i] = tweet
      else
        # TODO send error to hoptoad/exceptional?
        Rails.logger.error "Failed to save tweet: #{tweet.errors.full_messages.join('.')}"
      end
    end
    
    tweets
  end
  
  protected
  
    def self.searcher
      Twitter::Search.new.to(TWITTER_ID)
    end
  
  
end