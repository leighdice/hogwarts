require 'sinatra'
require 'mongo'
require 'json/ext'

configure do
  db = Mongo::Client.new([ '127.0.0.1:27017' ], :database => 'venues')  
  set :mongo_db, db[:venues]
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
  settings.mongo_db.find.to_a.to_json
end

# /venues/:id
# get venue by id
get '/venues/:id' do
  "params id == #{params[:id]}"
end

# /venues
# post new venue
post '/venues/?' do
  content_type :json
  db = settings.mongo_db
  result = db.insert_one params
  db.find(:_id => result.inserted_id).to_a.first.to_json
end

# /venues/:id
# delete venue by id
delete '/venues/:id/' do
  "Deleting id: #{params[:id]}"
end

