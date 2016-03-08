require 'sinatra'
require 'JSON'

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
  "returning all venues"
end

# /venues/:id
# get venue by id
get '/venues/:id' do
  "You're searching for id: #{params[:id]}"
end

# /venues
# post new venue
post '/venues' do
  "Adding venue #{params[:venue]}"
end

# /venues/:id
# delete venue by id
delete '/venues/:id/' do
  "Deleting id: #{params[:id]}"
end

