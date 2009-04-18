class HomeController < ApplicationController
  def index
    if params[:import] == 'now'
      raise 'importing'
      TwitterImporter.import!
    end
    
    unless params[:twitter_username].blank?
      redirect_to report_path(params[:twitter_username], params[:hashtag])
      return
    end
  end
  
  def report
  end

end
