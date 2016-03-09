require 'sinatra'
require 'mongoid'
require_relative 'models/venue'

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
  venue = Venue.find(params[:id])
  return {:status => 404, :message => venue.errors}.to_json if venue.nil?
  return venue.to_json
end

# /venues
# post new venue
post '/venues/new' do
  venue = Venue.new(JSON.parse(request.body.read))
  return {:status => 400, :message => venue.errors}.to_json unless venue.valid?
  venue.save
  return 201
end

# /venues/:id
# update venue by id
put '/venues/:id' do
  venue = Venue.find(params[:id])
  jdata = JSON.parse(request.body.read)
  return {:status => 404, :message => venue.errors}.to_json if venue.nil?

  # jdata.each do |key, value|
  #   puts key
  #   puts value
  # end
  venue.update(jdata)
  return {:status => 400, :message => venue.errors}.to_json unless venue.save!
  venue.save
  return 202
end

# /venues/:id
# delete venue by id
delete '/venues/:id' do
  venue = Venue.find(params[:id])
  return {:status => 404, :message => venue.errors}.to_json if venue.nil?
  venue.delete
  status 202
end

