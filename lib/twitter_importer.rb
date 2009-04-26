# Uses Twitter gem. http://github.com/jnunemaker/twitter/tree/master
class TwitterImporter

  class << self
    
    def import!(per_page=100)
      import_logging do
        since_id = Tweet.latest_id

        Rails.logger.info "Searching for new tweets since #{since_id}"

        # fetch all new tweets
        searcher = twitter_searcher.to(TWITTER_ID).since(since_id).per_page(per_page)
        search_results = fetch_pages(per_page) do |page|
          searcher.page(page).fetch.results
        end

        # TODO: Fetch direct messages?

        # write new tweets to database
        create_tweets(search_results) { |r| Tweet.build_for_status(r) }
      end
    end

    def retro_import!(per_page=100, username, hashtag)
      import_logging do
        searcher = Twitter::Search.new.per_page(per_page).from(username).hashed(hashtag)
        search_results = fetch_pages(per_page) do |page|
          searcher.page(page).fetch.results
        end
        
        create_tweets(search_results) do |r|
          # custom parsing for pre-existing tweets
          tweet = Tweet.new
        end
      end
    end

    
  protected
    def twitter_searcher
      Twitter::Search.new
    end
    
    def create_tweets(search_results)
      tweets = Array.new(search_results.size)
      search_results.each_with_index do |r, i|
        tweet = yield r

        # Don't fail too noisily... we want to continue processing!
        if tweet.save
          tweets[i] = tweet
        else
          # TODO send error to hoptoad/exceptional?
          Rails.logger.error "Failed to save tweet: #{tweet.errors.full_messages.join('.')}"
        end
      end
      
      tweets
    end
    
    def import_logging
      tweets_imported, duration = timer { yield }
      
      # log some stats about this import
      distinct_users = tweets_imported.map { |t| t.from_user }.uniq.size
      tweet_count = tweets_imported.compact.size # the number of non-nil entries
      error_count = tweets_imported.size - tweet_count # the number of nil entries
    
      Import.create! :tweets => tweet_count, :errs => error_count, 
          :distinct_users => distinct_users, :duration => duration    
    end
    
    def timer
      t0 = Time.now    
      yield, Time.now - t0
    end

    def fetch_pages(per_page)
      search_results = []
      page = 1

      while true
        Rails.logger.info "Fetching page #{page} (#{per_page} per page)"

        page_results = yield page
        search_results += page_results      

        # if we didn't get a full page, we're at the end
        break if page_results.size < per_page
        page += 1
      end    

      Rails.logger.info "Found #{search_results.size} new tweets"
      search_results
    end
  end
  
  
end