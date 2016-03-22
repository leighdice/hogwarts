require 'sinatra'
require 'mongoid'
require 'redis'
require 'logger'
require 'mongoid_search'
require 'murmurhash3'
require_relative 'models/venue'
require_relative 'helpers/errors'
require_relative 'helpers/request-timer'
require_relative 'helpers/redis-helper'

class VenueApp < Sinatra::Base

  helpers Errors, RequestTimer, RedisHelper
  File.open('venue_app.pid', 'w') {|f| f.write Process.pid }
  set :show_exceptions, false

  configure do
    enable :logging, :dump_errors, :run, :sessions

    # Connect to mongo
    Mongoid.configure do |config|
      config.sessions = {
        :default => {
          :hosts => ["localhost:27017"] || ENV['MONGO_URL'], :database => "venues"
        }
      }

      Mongoid.raise_not_found_error = false
    end

    # Create Log file
    $logfile = File.open('venues.log', File::WRONLY | File::APPEND | File::CREAT)
    $logfile.sync = true
    $logger = Logger.new($logfile)

    # Redis
    $redis = Redis.new(:host => ENV['REDIS_URL'] || "127.0.0.1", :port => ENV['REDIS_PORT'] || 6379)
    begin
      $redis.ping
    rescue Exception => e
      fail(e.message) if ENV['USE_REDIS']
    end
  end

  # Set default content type to json
  before do
    content_type 'application/json'
  end

  # set default 404 message
  error Sinatra::NotFound do
    return error_not_found_default
  end

  # Overide default 500
  error 500 do
    return error_500
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

    if can_use_redis?(request)
      venues = get_all_from_redis
    else
      venues = Venue.all
    end

    status 200
    headers["X-duration"] = request_timer_format(t)
    body
      { :duration => request_timer_format(t),
        :records  => venues}.to_json
  end

  # /venues/:id
  # get venue by id
  get '/venues/:id' do
    t = request_timer_start

    if can_use_redis?(request)
      venue = get_from_redis(params[:id])
    else
      venue = Venue.find(params[:id])
    end

    return error_not_found(params[:id]) if venue.nil?

    status 200
    headers["X-duration"] = request_timer_format(t)
    body
      { :duration => request_timer_format(t),
        :records  => [venue]}.to_json
  end

  # Search for venues
  get '/venues/search/:query' do
    t = request_timer_start

    if can_use_redis?(request)
      results = get_from_search_redis(params[:query])
    else
      results = Venue.full_text_search(params[:query])
    end

    status 200
    headers["X-duration"] = request_timer_format(t)
    body
      { :duration => request_timer_format(t),
        :records  => results}.to_json
  end

  # /venues
  # post new venue
  post '/venues/new' do
    t = request_timer_start

    # Create new venue from body
    # Return invalid if it doesnt pass validation
    venue = Venue.new(JSON.parse(request.body.read))
    return error_invalid(venue) unless venue.valid?

    # Save and add to redis, throw 500 if error
    begin
      venue.save!
      add_to_redis(venue.id, venue) if can_use_redis?(request)
    rescue Mongoid::Errors::Callback => e
      $logger.error(e.problem)
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

    # Fetch venue by id
    venue = Venue.find(params[:id])
    return error_not_found(params[:id]) if venue.nil?

    # Update attributes & add to redis
    begin
      venue.update_attributes!(JSON.parse(request.body.read))
      add_to_redis(venue.id, venue) if can_use_redis?(request)
    rescue Mongoid::Errors::Validations => e
      return error_invalid(venue)
    end

    # Return 500 if save fails
    begin
      venue.save!
    rescue Mongoid::Errors::Callback => e
      $logger.error(e.problem)
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
    begin
      venue.destroy
    rescue Exception => e
      $logger.error(e)
      return error_500
    end

    # Remove from redis
    del_from_redis(params[:id]) if can_use_redis?(request)

    # Return 204 if successful
    status 204
    headers["X-duration"] = request_timer_format(t)
  end
end
