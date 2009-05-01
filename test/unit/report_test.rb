require File.dirname(__FILE__) + '/../test_helper'

class ReportTest < ActiveSupport::TestCase

  test "without providing twitter username" do
    assert_raise(ArgumentError) { Report.new :hashtag => 'foo' }    
  end
  
  test "without providing hashtag" do
    assert_raise(ArgumentError) { Report.new :twitterer => 'foo' }
  end
  
  test "invalid twitter username raises InvalidTwitterUsername" do
    assert_raise(InvalidTwitterUsername) do
      Report.new :twitterer => 'bogus', :hashtag => 'foo'
    end
  end
  
  test "picture_description" do
    Factory :twitterer, :username => 'doctorzaius', :full_name => 'Doctor Zaius'
    report = Report.new :twitterer => 'doctorzaius', :hashtag => 'weight'
    assert_equal "Doctor Zaius's Twitter profile picture", report.picture_description
  end
  
  test "title defaults to titleized hashtag" do
    Factory :twitterer, :username => 'doctorzaius', :full_name => 'Doctor Zaius'
    report = Report.new :twitterer => 'doctorzaius', :hashtag => 'weight'
    assert_equal 'Weight', report.title
  end
  
  test "title specified" do
    Factory :twitterer, :username => 'doctorzaius', :full_name => 'Doctor Zaius'
    report = Report.new :twitterer => 'doctorzaius', :hashtag => 'weight', :title => 'My Title'
    assert_equal 'My Title', report.title
  end
  
  
end
