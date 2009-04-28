class ReportController < ApplicationController
  # Dummy action to handle report form at top of page, just redirects to proper URL.
  def redirector
    twitterer = params[:twitterer].gsub('@', '').strip
    hashtag = params[:hashtag].gsub('#', '').strip

    redirect_to report_path(:twitterer => twitterer, :hashtag => hashtag), :status => :moved_permanently
  end
  
  def show
    @twitterer = params[:twitterer].gsub('@', '').strip
    @hashtag = params[:hashtag].gsub('#', '').strip
    
    if @hashtag != params[:hashtag] || @twitterer != params[:twitterer]
      # clean up the URL
      redirect_to report_path(:twitterer => @twitterer, :hashtag => @hashtag), :status => :moved_permanently
      return
    end
    
    @report = Tweet.report :twitterer => @twitterer, :hashtag => @hashtag
    
    # Determine whether the page should do a background search for new tweets.
    # If it's been at least 60s since the last import, do it.
    @background_search = Import.last.created_at < 60.seconds.ago rescue false
  end

  def import
    user = params[:u]
    hashtag = params[:t]
    count_before_import = Tweet.for_report(user, hashtag).count

    begin
      # import new stuff
      import = TwitterImporter.import!
    rescue StandardError => e
      logger.error 'TwitterImporter.import! failed: ' + e
    end

    delta = 0
    if import && import.tweets > 0
      # We found something, but any new stuff from this person?
      count_after_import = Tweet.uncached { Tweet.for_report(user, hashtag).count }
      delta = count_after_import - count_before_import
    end

    render :json => delta.to_json
  end
  
end
