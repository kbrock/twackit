class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :fancy_quote

  # before_filter :log_request

  # filter_parameter_logging :password

  protected

  def fancy_quote(str)
    "&#147;#{str}&#148;".html_safe
  end


  def log_request
    PageRequest.log(session[:session_id],cookies, request)
  end
end
