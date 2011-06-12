ActionController::Routing::Routes.draw do |map|
  map.root :controller => "home"
  map.faq 'faq', :controller => 'home', :action => 'faq'

  map.report ':twitterer/:hashtag', :controller => 'report', :action => 'show'
  map.to_report 'report', :controller => 'report', :action => 'redirector'
  map.import 'import', :controller => 'report', :action => 'import'
end
