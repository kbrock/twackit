class ReportController < ApplicationController
  def show
    @twitter_username = params[:twitter_username].strip
    @hashtag = params[:hashtag].gsub('#', '').strip
    
    if @hashtag != params[:hashtag] || @twitter_username != params[:twitter_username]
      # clean up the URL
      redirect_to report_path(:twitter_username => @twitter_username, :hashtag => @hashtag), :status => :moved_permanently
      return
    end
    
    # redirect_to root_url and return if @twitter_username.blank? || @hashtag.blank?
    
    @report = Tweet.report :twitter_username => @twitter_username, :hashtag => @hashtag
    
    # determine whether the page should do a background search for new tweets
    # if it's been at least 60s since the last import, do it
    @background_search = Import.last.created_at < Time.now - 60 rescue true
  end

  def import
    user = params[:u]
    hashtag = params[:t]
    
    count_before_import = Tweet.for_report(user, hashtag).count

    # import new stuff
    import = TwitterImporter.import!

    if import.tweets > 0
      # we found something, but any new stuff from this person?
      count_after_import = Tweet.uncached { Tweet.for_report(user, hashtag).count }
      delta = count_after_import - count_before_import
    
      if delta > 0
        return render :json => delta.to_json
      end
    end
    
    render :nothing => true, :layout => false
  end
  
end
