require 'date'
require_relative 'app_spec_helper'

describe "Get Requests" do

  describe "Get by ID" do

    id = "56e402521338596b67000030"
    get "/venues/#{id}"
    response = last_response

    it "should return venue record" do
      jdata = JSON.parse(response.body)
      venue_object = jdata["records"].first
      expect(venue_object).to match(expected_venue_record)
    end

    it "should response with code 200" do
      expect(response.status).to eql(200)
    end

    it "should respond with duration in header" do
      expect(response.header["x-duration"].to_s).to match(/(\d)$/)
    end

    it "should respond with duration in body" do
      jdata = JSON.parse(response.body)
      expect(jdata["duration"]).to match(/(\d)$/)
    end
  end

  describe "Get invalid id" do

    id = "someInvalidID"
    get "/venues/#{id}"
    response = last_response

    it "should respond with 404" do
      expect(response.status).to eql(404)
    end

    it "should return body error" do
      jdata = response.body
      expect(jdata).to eql(not_found_with_id_error(id))
    end
  end

  describe "Get all venues" do

    get '/venues'
    response = last_response

    it "should return array of venues" do
      jdata = JSON.parse(response.body)
      # Check for an array for now, need to be cleverer with this
      expect(jdata["records"]).to be_an_instance_of(Array) 
    end

    it "should respond with 200" do
      expect(response.status).to eql(200)
    end

    it "should respond with duration in header" do
      expect(response.header["x-duration"].to_s).to match(/(\d)$/)
    end

    it "should respond with duration in body" do
      jdata = JSON.parse(response.body)
      expect(jdata["duration"]).to match(/(\d)$/)
    end
  end

  describe "Get invalid url" do

    get '/vnue'
    response = last_response

    it "should respond with status 404" do
      expect(response.status).to eql(404)
    end

    it "should respond with default not found body" do
      jdata = response.body
      expect(jdata).to eql({ :error => "These are not the links you're looking for",
                              :code => 404,
                              :description => "Not found",
                              :messages => ["The url you requested is invalid"]}.to_json)
    end
  end
end
