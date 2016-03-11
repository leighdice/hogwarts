require_relative File.join(File.dirname(__FILE__), '../app.rb')
require 'rspec'
require 'rack/test'

set :environment, :test


include Rack::Test::Methods

def app
  Sinatra::Application
end

