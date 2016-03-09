require 'sinatra'
require 'mongoid'
require_relative 'models/venue'

#Mongoid.load!("mongoid.yml")

configure :development do
  enable :logging, :dump_errors, :run, :sessions
  Mongoid.load!(File.join(File.dirname(__FILE__), "config", "mongoid.yml"))
end

get '/' do
  "Hello world!"
end

# /version
# get current version of app
get '/version' do
  "1.0.0"
end

# /venues
# get all venues
get '/venues' do
  content_type :json
  Venue.all.to_json
end

# /venues/:id
# get venue by id
get '/venues/:id' do

end

# /venues
# post new venue
post '/venues/new' do
  jdata = JSON.parse(request.body.read)
  venue = Venue.new(jdata)
  return {:status => 400, :message => venue.errors}.to_json unless venue.valid?
  return 201
end

# /venues/:id
# delete venue by id
delete '/venues/:id/' do
  "Deleting id: #{params[:id]}"
end

