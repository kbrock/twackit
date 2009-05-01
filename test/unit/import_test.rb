require File.dirname(__FILE__) + '/../test_helper'

class ImportTest < ActiveSupport::TestCase
  test "create" do
    Import.create! :tweets => 5, 
        :distinct_users => 3,
        :errs => 1, :duration => 10
    
    assert_equal 1, Import.count
  end
end
