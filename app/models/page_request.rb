class PageRequest < ActiveRecord::Base

  def self.log(session_id, cookies, request)
    create :url => request.url,
      :method => request.method.id2name,
      :user_agent => request.user_agent,
      :remote_ip => request.remote_ip,
      :referrer => request.referrer,
      :xhr => request.xhr?,
      :session_id => session_id,
      :cookies => cookies.inspect
  end
end
