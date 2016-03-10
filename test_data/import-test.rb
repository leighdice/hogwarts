require 'pp'
require 'json'

def generate_venue(v, a, c, id)

  begin
  
    address_line_1 = a.match(/^[^,]+/)[0]
    address_line_2 = a.match(/,\s(.+),/)[1] || ""
    address_line_3 = a.match(/,\s(.+),/)[2] || ""

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

@venue_array = []
@exceptions = []

events_dump.each do |e|

  if e["cities"].count > 1
    @exceptions.push(e["_id"])
  elsif !e["address"].include? ","
    @exceptions.push(e["id"])
  else
    cities = e["cities"].first
    city_name = cities["name"]

    venue = generate_venue(e["venue"], e["address"], city_name, e["id"])
    unless venue.nil?
      @venue_array.push(venue) unless @venue_array.include?(venue)
    end
  end
end

@venue_array.each do |v|
  puts JSON.pretty_generate(v)
end
puts "Exception: #{@exceptions.count}"
puts "Successful: #{@venue_array.count}"
