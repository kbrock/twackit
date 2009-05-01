require File.dirname(__FILE__) + '/../test_helper'

class ReportControllerTest < ActionController::TestCase

  test "GET redirector redirects to report/show" do
    get :redirector, :twitterer => 'doctorzaius', :hashtag => 'weight'
    assert_response :redirect
    assert_redirected_to :controller => 'report', :action => 'show', 
        :twitterer => 'doctorzaius', :hashtag => 'weight'
  end

  test "GET show" do
    Factory :twitterer, :username => 'doctorzaius'
    get 'show', :twitterer => 'doctorzaius', :hashtag => 'weight'
    assert_response :ok

    assert_equal 'doctorzaius', assigns(:twitterer)
    assert_equal 'weight', assigns(:hashtag)
    assert_not_nil assigns(:report)
    assert_equal true, assigns(:background_search)
  end
  
  test "GET show with # in hashtag redirects to clean URL" do
    Factory :twitterer, :username => 'doctorzaius'
    get 'show', :twitterer => 'doctorzaius', :hashtag => '#weight'
    assert_response :moved_permanently
    assert_redirected_to :twitterer => 'doctorzaius', :hashtag => 'weight'
  end

  test "GET show with @ in twitter username redirects to clean URL" do
    Factory :twitterer, :username => 'doctorzaius'
    get 'show', :twitterer => '@doctorzaius', :hashtag => 'weight'
    assert_response :moved_permanently
    assert_redirected_to :twitterer => 'doctorzaius', :hashtag => 'weight'
  end
  
  test "GET show with spaces in params redirects to clean URL" do
    Factory :twitterer, :username => 'doctorzaius'
    get 'show', :twitterer => ' doctorzaius ', :hashtag => ' weight '
    assert_response :moved_permanently
    assert_redirected_to :twitterer => 'doctorzaius', :hashtag => 'weight'
  end

  test "GET show with invalid twitter username redirects to FAQ" do
    Factory :twitterer, :username => 'doctorzaius'
    get 'show', :twitterer => 'bob', :hashtag => 'weight'
    assert_response :redirect
    assert_redirected_to faq_path

    assert_equal 'bob', assigns(:twitterer)
    assert_equal 'weight', assigns(:hashtag)
    assert_nil assigns(:report)
    assert_nil assigns(:background_search)    
  end
end
