require 'pp'
require 'json'

#events_dump = JSON.parse(File.open("events_small.json").read)

def get_city(id)

  if id.eql? "54d8a23438fe5d27d500001c"
    return "London"
  elsif id.eql? "54d8a22538fe5d27d5000019"
    return "Manchester"
  elsif id.eql? "54d8a20238fe5d27d5000013"
    return "Glasgow"
  elsif id.eql? "5593f5d476b8b0c87b649241"
    return "Cardiff"
  elsif id.eql? "54d8a21638fe5d27d5000016"
    return "Bristol"
  else
    return "undefined"
  end
end

def generate_venue(v, a, c, id)

  begin
  
    address_line_1 = a.match(/^(.+),/)[1]
    address_line_2 = a.match(/^(.+),/)[2] || ""
    address_line_3 = a.match(/^(.+),/)[3] || ""
    
    without_address = a.gsub(address_line_1, "")
    puts without_address
    postcode = without_address.match(/,[\s]\S+[\s](.+)$/)[1]
  rescue Exception => e
    @exceptions.push(id)
    return nil
  end

  return {
    name: v,
    address_line_1: address_line_1,
    address_line_2: address_line_2,
    address_line_3: address_line_3,
    city: c,
    country: "United Kingdom",
    postcode: postcode
  }
end


file = File.open("eventList.json").read
events_dump = JSON.parse(file)

venue_array = []
@exceptions = []

events_dump.each do |e|

  if e["cities"].count > 1
    @exceptions.push(e["_id"])
  elsif !e["address"].include? ","
    @exceptions.push(e["id"])
  else
    cities = e["cities"].first
    city_name = cities["name"]

    venue = generate_venue(e["venue"], e["address"], city_name, e["_id"])
    venue_array.push(venue) unless venue.nil?
  end
end

venue_array.each do |v|
  puts JSON.pretty_generate(v)
end
puts @exceptions.count
