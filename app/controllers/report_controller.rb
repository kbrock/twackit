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
  end
  
end
