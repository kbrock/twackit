# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  helper_method :fancy_quote
  
  # before_filter :log_request

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  # protect_from_forgery :secret => 'c65e0f845ac21f55b3fa352ba4eaeaca'
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  # filter_parameter_logging :password
  
  
protected
  def fancy_quote(str)
    "&#147;#{str}&#148;"
  end


  def log_request
    PageRequest.log(session[:session_id],cookies, request)
  end
end
