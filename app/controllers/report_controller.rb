class ReportController < ApplicationController
  def show
    @twitter_username = params[:twitter_username].strip
    @hashtag = params[:hashtag].gsub('#', '').strip
    
    # redirect_to root_url and return if @twitter_username.blank? || @hashtag.blank?
    
    @report = Tweet.report :twitter_username => @twitter_username, :hashtag => @hashtag
  end
  
end
