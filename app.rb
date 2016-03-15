require 'sinatra'
require 'mongoid'
require 'redis'
require_relative 'models/venue'
require_relative 'helpers/errors'
require_relative 'helpers/request-timer'

class VenueApp < Sinatra::Base

  helpers Errors, RequestTimer
  File.open('venue_app.pid', 'w') {|f| f.write Process.pid }
  set :show_exceptions, false
  set :raise_errors, true

  configure :development do
    enable :logging, :dump_errors, :run, :sessions
    Mongoid.load!(File.join(File.dirname(__FILE__), 'config/mongoid.yml'), :development)
    Mongoid.raise_not_found_error = false
    $redis = Redis.new()
    $DEFAULT_REDIS_EX = 300
  end

  # Set default content type to json
  before do
    content_type 'application/json'
  end

  # set default 404 message
  error Sinatra::NotFound do
    return error_not_found_default
  end

  error do
    return error_500_with_message
  end

  # /version
  # get current version of app
  get '/version' do
    t = request_timer_start
    status 200
    headers["X-duration"] = request_timer_format(t)
    body
      { :version => "0.0.1"}.to_json
  end

  # /venues
  # get all venues
  get '/venues' do
    t = request_timer_start
    status 200
    headers["X-duration"] = request_timer_format(t)
    body
      { :duration => request_timer_format(t),
        :records  => Venue.all}.to_json
  end

  # /venues/:id
  # get venue by id
  get '/venues/:id' do
    t = request_timer_start
      
    if $redis.exists(params[:id])
      venue = JSON.parse($redis.get(params[:id]))
    else
      venue = Venue.find(params[:id])
      $redis.set(params[:id], venue.to_json, {:ex => $DEFAULT_REDIS_EX})
    end

    return error_not_found(params[:id]) if venue.nil?

    status 200
    headers["X-duration"] = request_timer_format(t)
    body
      { :duration => request_timer_format(t),
        :records  => [venue]}.to_json
  end

  # /venues
  # post new venue
  post '/venues/new' do
    t = request_timer_start
    venue = Venue.new(JSON.parse(request.body.read))
    return error_invalid(venue) unless venue.valid?
    
    # Return 500 if save fails
    begin
      venue.save!
    rescue Mongoid::Errors::Callback
      # TODO - log panic here
      return error_500
    end

    status 201
    body
      { :duration => request_timer_format(t)}.to_json
  end

  # /venues/:id
  # update venue by id
  put '/venues/:id' do
    t = request_timer_start

    venue = Venue.find(params[:id])
    jdata = JSON.parse(request.body.read)
    return error_not_found(params[:id]) if venue.nil?

    begin
      venue.update_attributes!(jdata)
    rescue Mongoid::Errors::Validations
      return error_invalid(venue)
    end

    # Return 500 if save fails
    begin
      venue.save!
    rescue Mongoid::Errors::Callback
      # TODO - log panic here
      return error_500
    end

    status 204
    headers["X-duration"] = request_timer_format(t)
  end

  # /venues/:id
  # delete venue by id
  delete '/venues/:id' do
    t = request_timer_start

    # Find venue by id
    venue = Venue.find(params[:id])
    return error_not_found(params[:id]) if venue.nil?

    # Return 500 if failed to delete
    return error_500 unless venue.destroy
    $redis.del(params[:id])

    # Return 204 if successful
    status 204
    headers["X-duration"] = request_timer_format(t)
  end
end
