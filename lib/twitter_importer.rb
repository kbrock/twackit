# Uses Twitter gem. http://github.com/jnunemaker/twitter/tree/master
class TwitterImporter

  class << self
    
    def import!(per_page=100)
      import_logging do
        since_id = Tweet.latest_id

        Rails.logger.info "Searching for new tweets since status #{since_id}"

        # fetch all new tweets
        searcher = twitter_searcher.referencing(TWITTER_ID).since(since_id).per_page(per_page)
        search_results = fetch_pages(per_page) do |page|
          searcher.page(page).fetch.results
        end

        # TODO: Fetch direct messages?

        # write new tweets to database
        create_tweets(search_results) { |status| Tweet.build_for_status(status) }
      end
    end

    # Import "retroactive" tweets, for people who were using Twitter to track
    # stuff before @twackit existed.
    def retro_import!(username, hashtag, per_page=100)
      # Do a regular import first, to make sure we don't skip any @twackit tweets
      # that have status_id earlier than the lastest non-@twackit tweets.
      import!(per_page)
      
      import_logging do
        searcher = Twitter::Search.new.per_page(per_page).from(username).hashed(hashtag)
        search_results = fetch_pages(per_page) do |page|
          searcher.page(page).fetch.results
        end
        
        create_tweets(search_results) { |status| Tweet.build_for_retro_status(status) }
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
        tweet.save!
        # if tweet.save
        #   tweets[i] = tweet
        # else
        #   # TODO send error to hoptoad/exceptional?
        #   Rails.logger.error "Failed to save tweet: #{tweet.errors.full_messages.join('.')}"
        # end
      end
      
      tweets
    end
    
    # Given a block that performs import and returns the tweets that were
    # imported, writes metrics to Import log table.
    def import_logging
      tweets_imported, duration = timer { yield }
      valid_tweets = tweets_imported.compact
      
      # log some stats about this import
      distinct_users = valid_tweets.map { |t| t.from_user }.uniq.size
      tweet_count = valid_tweets.size # the number of non-nil entries
      error_count = tweets_imported.size - tweet_count # the number of nil entries
    
      Import.create! :tweets => tweet_count, :errs => error_count, 
          :distinct_users => distinct_users, :duration => duration    
    end
    
    # Given a block, returns result of the block and duration (in seconds) 
    # that it took to execute.
    def timer
      t0 = Time.now  
      result = yield
      duration = Time.now - t0
      [result, duration]
    end

    # Implements algorithm to dynamically fetch pages of data. Provide a
    # block that performs fetch for each page. Returns accumulated results 
    # for all pages.
    def fetch_pages(per_page)
      results = []
      page = 1

      while true
        Rails.logger.info "Fetching page #{page} (#{per_page} per page)"

        page_results = yield page
        results += page_results      

        # if we didn't get a full page, we're at the end
        break if page_results.size < per_page
        page += 1
      end    

      Rails.logger.info "Found #{results.size} new tweets"
      results
    end
  end
  
  
end