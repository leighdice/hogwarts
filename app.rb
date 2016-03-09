require 'sinatra'
require 'mongoid'
require_relative 'models/venue'
require_relative 'helpers/errors'

helpers Errors

not_found do
  "This is not the url you're looking for"
end

configure :development do
  enable :logging, :dump_errors, :run, :sessions
  Mongoid.load!(File.join(File.dirname(__FILE__), "config", "mongoid.yml"))
  Mongoid.raise_not_found_error = false
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
  return error_not_found(params[:id]) if venue.nil?
  return venue.to_json
end

# /venues
# post new venue
post '/venues/new' do
  venue = Venue.new(JSON.parse(request.body.read))
  return error_invalid(venue) unless venue.valid?
  venue.save
  return 201
end

# /venues/:id
# update venue by id
put '/venues/:id' do
  venue = Venue.find(params[:id])
  jdata = JSON.parse(request.body.read)
  return error_not_found(params[:id]) if venue.nil?

  begin
    venue.update_attributes!(jdata)
  rescue Mongoid::Errors::Validations
    return error_invalid(venue)
  end

  venue.save
  return 202
end

# /venues/:id
# delete venue by id
delete '/venues/:id' do
  venue = Venue.find(params[:id])
  return error_not_found(params[:id]) if venue.nil?
  venue.delete
  status 204
end

