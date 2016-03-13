require_relative File.join(File.dirname(__FILE__), '../app.rb')
require_relative File.join(File.dirname(__FILE__), '/support/test_helper.rb')
require 'rspec'
require 'rack/test'
require 'mongoid'

set :environment, :test


include Rack::Test::Methods
include TestHelper

def app
  VenueApp
end

