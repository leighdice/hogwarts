require 'json'
require 'net/http'
require 'uri'

@uri = URI.parse("http://localhost:4567")

def get_all_venues

  http = Net::HTTP.new(@uri.host, @uri.port)
  request = Net::HTTP::Get.new("/venues")
  request.add_field('Content-Type', 'application/json')
  response = http.request(request)
  
  return JSON.parse(response.body)
end

def delete_all_venues

  venues = get_all_venues["records"]
  ids = []
  venues.each {|v| ids.push(v["_id"])}
  http = Net::HTTP.new(@uri.host, @uri.port)
  
  ids.each do |id|
    request = Net::HTTP::Delete.new("/venues/#{id}")
    request.add_field('Content-Type', 'application/json')
    response = http.request(request)
    puts response.code
  end
end

delete_all_venues
