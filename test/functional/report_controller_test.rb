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

    assert_not_nil assigns(:tag)
    assert_equal 'doctorzaius', assigns(:tag).username
    assert_equal 'weight', assigns(:tag).tag
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
    Twitterer.any_instance.stubs(:twitter_user).returns(nil)
    Factory :twitterer, :username => 'doctorzaius'
    get 'show', :twitterer => 'bob', :hashtag => 'weight'
    assert_response :redirect
    assert_redirected_to faq_path

    assert_nil assigns(:report)
    assert_nil assigns(:background_search)    
  end
end
