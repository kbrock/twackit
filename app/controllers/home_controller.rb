class HomeController < ApplicationController
  def index
    @recent_tweets = Tweet.recent
  end
  
  def faq    
  end

end
