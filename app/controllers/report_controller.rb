class ReportController < ApplicationController
  def show
    @twitter_username = params[:twitter_username].strip
    @hashtag = params[:hashtag].gsub('#', '').strip
    @report = Tweet.report :twitter_username => @twitter_username, :hashtag => @hashtag
  end
  
end
