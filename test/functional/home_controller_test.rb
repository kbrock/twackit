require File.dirname(__FILE__) + '/../test_helper'

class HomeControllerTest < ActionController::TestCase
  test "GET root" do
    get 'index'
    assert_response :ok
    assert_template 'index'
  end
  
  test "GET faq" do
    get 'faq'
    assert_response :ok
    assert_template 'faq'
  end
end
