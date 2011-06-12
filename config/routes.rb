Twackit::Application.routes.draw do
  root :to => 'home#index'
  match 'faq' => 'home#faq', :as => :faq
  match ':twitterer/:hashtag' => 'report#show', :as => :report
  match 'report' => 'report#redirector', :as => :to_report
  match 'import' => 'report#import', :as => :import
end
