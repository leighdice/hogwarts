require 'sinatra'
require 'mongoid'
require 'redis'
require_relative 'models/venue'
require_relative 'helpers/errors'
require_relative 'helpers/request-timer'
require_relative 'helpers/redis-helper'

class VenueApp < Sinatra::Base

  helpers Errors, RequestTimer, RedisHelper
  File.open('venue_app.pid', 'w') {|f| f.write Process.pid }
  set :show_exceptions, false

  configure :development do
    enable :logging, :dump_errors, :run, :sessions
    Mongoid.load!(File.join(File.dirname(__FILE__), 'config/mongoid.yml'), :development)
    Mongoid.raise_not_found_error = false
    $redis = Redis.new(:host => ENV['REDIS_URL'] || "127.0.0.1", :port => ENV['REDIS_PORT'] || 6379)

    # Ping redis to check connection
    begin
      $redis.ping
    rescue Exception => e
      fail(e.message)
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

    if request.env["HTTP_X_NO_REDIS"] || ENV['USE_REDIS'] == false
      puts "REDIS FREE request"
      venues = Venue.all
    else
      puts "not so redis free request"
      venues = get_all_from_redis
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

    # Attempt to fetch from redis
    # If key does not exist, fetch from db and create new key

    if $redis.hexists("venues", params[:id])
      venue = JSON.parse($redis.hget("venues", params[:id]))
    else
      venue = Venue.find(params[:id])
      return error_not_found(params[:id]) if venue.nil?
      $redis.hset("venues", params[:id], venue.to_json)
    end

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

    # Create new venue from body
    # Return invalid if it doesnt pass validation
    venue = Venue.new(JSON.parse(request.body.read))
    return error_invalid(venue) unless venue.valid?

    # Save and add to redis, throw 500 if error
    begin
      venue.save!
      $redis.hset("venues", venue.id, venue.to_json)
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

    # Fetch venue by id
    venue = Venue.find(params[:id])
    return error_not_found(params[:id]) if venue.nil?

    # Update attributes & add to redis
    begin
      venue.update_attributes!(JSON.parse(request.body.read))
      $redis.hset("venues", venue.id, venue.to_json)
    rescue Mongoid::Errors::Validations
      # TODO - log errors
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

    # Remove from redis
    $redis.hdel("venues", params[:id])

    # Return 204 if successful
    status 204
    headers["X-duration"] = request_timer_format(t)
  end
end
