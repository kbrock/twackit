class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper :calendar
  helper_method :fancy_quote
  # before_filter :log_request

  protected

  def fancy_quote(str)
    "&#147;#{str}&#148;".html_safe
  end


  def log_request
    PageRequest.log(session[:session_id],cookies, request)
  end

  #protect_from_forgery
end
