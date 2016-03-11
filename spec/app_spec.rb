require_relative File.join(File.dirname(__FILE__), '../app.rb')
require 'rspec'
require 'rack/test'

set :environment, :test

describe 'VenueApp' do

  include Rack::Test::Methods

  def app
    Sinatra::Application
  end

  it "should respond with version number" do
    get '/version'
    res = JSON.parse(last_response.body)
    expect(res["version"]).to eql("0.0.1")
  end
end
