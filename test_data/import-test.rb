require 'pp'
require 'json'
require 'net/http'
require 'uri'
require 'openssl'

@venue_array = []
@exceptions = []


def generate_venue(v, a, c, id)

  begin
  
    address_line_1 = a.match(/^[^,]+/)[0]
    address_line_2 = a.match(/,\s(.+),/)[1] || ""
    address_line_3 = a.match(/,\s(.+),/)[2] || ""

    # do we need address line 3
    if address_line_2.include? ","
      split = a.split(", ")
      address_line_2 = split[1]
      address_line_3 = split[2]
    end

    postcode_and_city = a.gsub(address_line_1, "")
    postcode_and_city = postcode_and_city.gsub(address_line_2, "")
    postcode_and_city = postcode_and_city.gsub(address_line_3, "")

    pm = postcode_and_city.scan(/\s(\w+)/).to_a

    if pm.count == 3
      city = pm[0][0]
      postcode = pm[1][0] + " " + pm[2][0]
    else
      @exceptions.push(id)
      return nil
    end
      

  rescue Exception => e
    #puts e
    @exceptions.push(id)
    return nil
  end

  return {
    name: v,
    address_line_1: address_line_1,
    address_line_2: address_line_2,
    address_line_3: address_line_3,
    city: city,
    country: "United Kingdom",
    postcode: postcode
  }
end


file = File.open("eventList.json").read
events_dump = JSON.parse(file)

events_dump.each_with_index do |e, i|

  if e["cities"].count > 1
    @exceptions.push(e["_id"])
  elsif !e["address"].include? ","
    @exceptions.push(e["id"])
  else
    cities = e["cities"].first
    city_name = cities["name"]

    venue = generate_venue(e["venue"], e["address"], city_name, e["id"])
    unless venue.nil?
      @venue_array.push(venue)
    end
  end
end



puts "Exception: #{@exceptions.count}"
puts "Successful: #{@venue_array.count}"

puts "Removing duplicates"
@venue_array = @venue_array.uniq { |v| v[:name]}
puts "Successful: #{@venue_array.count}"

File.open("venue_list.json","w") do |f|
  f.write(JSON.pretty_generate(@venue_array))
end

puts "Starting to post to local..."
@venue_array.each do |v|

  uri = URI.parse("http://localhost:4567")
  http = Net::HTTP.new(uri.host, uri.port)
  #http.use_ssl = true
  #http.verify_mode = OpenSSL::SSL::VERIFY_NONE
  request = Net::HTTP::Post.new("/venues/new")
  request.add_field('Content-Type', 'application/json')
  request.body = v.to_json
  response = http.request(request)
  puts response
end
