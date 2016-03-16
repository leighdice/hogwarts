var today = ISODate();
var venue = {  
  "_id" : ObjectId("56e9ecd8b9fcc9f549a1981a"),
  "name": "Plymouth Pavillions",
  "address_line_1" : "Millbay Rd",
  "address_line_2" : "",
  "address_line_3" : "",
  "city" : "Plymouth",
  "country" : "United Kingdom",
  "county" : "",
  "postcode" : "PL1 3LF",
  "created_at" : today,
  "updated_at" : today
}

db.venues.insert(venue)
