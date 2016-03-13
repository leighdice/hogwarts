require_relative 'app.rb'
Mongoid.load!(File.join(File.dirname(__FILE__), 'config/mongoid.yml'))
run VenueApp
