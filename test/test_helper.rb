$:.reject! { |e| e.include? 'TextMate' }
ENV["RAILS_ENV"] = "test"
require 'redgreen' unless ENV['TM_MODE']

#catch unintentional calls to object.id
Object.send(:undef_method, :id) if Object.respond_to?(:id)
NilClass.send(:undef_method, :id) if NilClass.respond_to?(:id)
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

class ActiveSupport::TestCase
  # self.use_transactional_fixtures = true
  # Add more helper methods to be used by all tests here...
end
