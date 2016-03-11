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

# Set default content type to json
before do
  content_type 'application/json'
end

# set default 404 message
error Sinatra::NotFound do
  content_type :json
  (status 404 ; body
  { :error => "These are not the links you're looking for",
    :code => 404,
    :description => "Not found",
    :messages => ["The url you requested is invalid"]}.to_json)
end

# /version
# get current version of app
get '/version' do
  status 200
  body
    { :version => "0.0.1"}.to_json
end

# /venues
# get all venues
get '/venues' do
  t = request_timer_start
  status 200
  body
    { :duration => request_timer_format(t),
      :records  => Venue.all}.to_json
end

# /venues/:id
# get venue by id
get '/venues/:id' do
  t = request_timer_start
  venue = Venue.find(params[:id])

  return error_not_found(params[:id]) if venue.nil?

  status 200
  body
    { :duration => request_timer_format(t),
      :records  => venue.to_a}.to_json
end

# /venues
# post new venue
post '/venues/new' do
  t = request_timer_start
  venue = Venue.new(JSON.parse(request.body.read))
  return error_invalid(venue) unless venue.valid?
  venue.save

  status 201
  body
    { :duration => request_timer_format(t)}.to_json
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

