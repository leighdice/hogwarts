require 'sinatra'
require 'mongoid'
require_relative 'models/venue'
require_relative 'helpers/errors'
require_relative 'helpers/request-timer'

helpers Errors, RequestTimer

configure :development do
  enable :logging, :dump_errors, :run, :sessions
  Mongoid.load!(File.join(File.dirname(__FILE__), "config", "mongoid.yml"))
  Mongoid.raise_not_found_error = false
end

# /version
# get current version of app
get '/version' do
  "0.0.1"
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
  t = request_timer_start
  venue = Venue.find(params[:id])

  if venue.nil?
    return error_not_found(params[:id])
  end

  venue.to_json
  status 200
  body request_timer_format(t)
end

# /venues
# post new venue
post '/venues/new' do
  venue = Venue.new(JSON.parse(request.body.read))
  return error_invalid(venue) unless venue.valid?
  venue.save
  status 201
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
  status 204
end

# /venues/:id
# delete venue by id
delete '/venues/:id' do
  venue = Venue.find(params[:id])
  return error_not_found(params[:id]) if venue.nil?
  venue.delete
  status 204
end

