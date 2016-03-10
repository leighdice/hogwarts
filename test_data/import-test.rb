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

def generate_venue(v, a, c)
  
  address_line_1 = a.match(/^(.+),/)[1]
  address_line_2 = a.match(/^(.+),/)[2] || ""
  address_line_3 = a.match(/^(.+),/)[3] || ""
  postcode = a.match(/,[\s]\S+[\s](.+)$/)[1]

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
exceptions = []

events_dump.each do |e|

  if e["references"]["cities"].count > 1
    exceptions.push(e["_id"])
  else
    cities = e["references"]["cities"].first
    city_id = cities["city_id"]["$oid"]

    venue_array.push(generate_venue(e["venue"], e["address"], get_city(city_id)))
  end
end

venue_array.each do |v|
  puts JSON.pretty_generate(v)
end
