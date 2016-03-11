require_relative 'app_spec_helper'

describe "Get Requests" do

  describe "Get by ID" do

    id = "56e2c59861aeb62eb600002f"

    it "should return venue record" do
      get "/venues/#{id}"
      jdata = JSON.parse(last_response.body)
      expect(jdata["records"]).to eql([
      {
        "_id" => "56e2c59861aeb62eb600002f",
        "address_line_1" => "Richmond Building",
        "address_line_2" => "University of Bristol Students' Union",
        "address_line_3" => "105 Queens Rd",
        "city" => "Bristol",
        "country" => "United Kingdom",
        "county" => "",
        "created_at" => "2016-03-11T13:18:16+00:00",
        "name" => "Anson Rooms",
        "postcode" => "BS8 1LN",
        "updated_at" => "2016-03-11T13:18:16+00:00"
      }])
    end

    it "should response with code 200" do
      get "/venues/#{id}"
      expect(last_response.status).to eql(200)
    end

    it "should respond with duration in header" do
      get "/venues/#{id}"
      expect(last_response.header["x-duration"].to_s).to match(/(\d)$/)
    end

    it "should respond with duration in body" do
      get "/venues/#{id}"
      jdata = JSON.parse(last_response.body)
      expect(jdata["duration"]).to match(/(\d)$/)
    end
  end

  describe "Get invalid id" do

    it "should respond with 404" do
      get '/venues/123'
      expect(last_response.status).to eql(404)
    end

    it "should return body error" do
      get '/venues/123'
      jdata = last_response.body
      expect(jdata).to eql({ :error => "Unable to find venue",
                              :code  => 404,
                              :description => "Not found",
                              :messages => ["Unable to find venue by id: 123"]}.to_json)
    end
  end

  describe "Get all venues" do

    it "should return array of venues" do
      puts "TODO"
    end

    it "should respond with 200" do
      get '/venues'
      expect(last_response.status).to eql(200)
    end

    it "should respond with duration in header" do
      get '/venues'
      expect(last_response.header["x-duration"].to_s).to match(/(\d)$/)
    end

    it "should respond with duration in body" do
      get "/venues"
      jdata = JSON.parse(last_response.body)
      expect(jdata["duration"]).to match(/(\d)$/)
    end
  end

  describe "Get invalid url" do

    it "should respond with status 404" do
      get '/vnue'
      expect(last_response.status).to eql(404)
    end

    it "should respond with default not found body" do
      get '/vnue'
      jdata = last_response.body
      expect(jdata).to eql({ :error => "These are not the links you're looking for",
                              :code => 404,
                              :description => "Not found",
                              :messages => ["The url you requested is invalid"]}.to_json)
    end
  end
end
