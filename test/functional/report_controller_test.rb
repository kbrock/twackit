require 'test_helper'

class ReportControllerTest < ActionController::TestCase

  test "GET redirector redirects to report/show" do
    get :redirector, :twitterer => 'doctorzaius', :hashtag => 'weight'
    assert_response :redirect
    assert_redirected_to :controller => 'report', :action => 'show', 
        :twitterer => 'doctorzaius', :hashtag => 'weight'
  end

  test "GET show" do
    # map.report ':twitterer/:hashtag', :controller => 'report', :action => 'show'
    
    get '/doctorzaius/weight'
    assert_response :ok
  end
  
end
