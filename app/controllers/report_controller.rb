class ReportController < ApplicationController
  def show
    @twitter_username = params[:twitter_username]
    @hashtag = params[:hashtag]
    @report = Tweet.report(
        :twitter_username => @twitter_username, 
        :hashtag => @hashtag
        )
  end
  
end
