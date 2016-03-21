require_relative 'app_spec_helper'

describe "Search" do

  describe "search by name" do
    get 'venues/search/blue'
    response = last_response

    it "should respond with venue matching the name" do
      jdata = JSON.parse(response.body)
      venue_object = jdata["records"].first
      expect(venue_object).to match(expected_search_result_venue_record)
    end

    it "should response with code 200" do
      expect(response.status).to eql(200)
    end

    it "should respond with duration in header" do
      expect(response.header["x-duration"].to_s).to match(/(\d)$/)
    end
  end

  describe "search by address" do
    get 'venues/search/eastern'
    response = last_response

    it "should respond with venues matching the address" do
      jdata = JSON.parse(response.body)
      venue_object = jdata["records"].first
      expect(venue_object).to match(expected_search_result_venue_record)
    end

    it "should response with code 200" do
      expect(response.status).to eql(200)
    end

    it "should respond with duration in header" do
      expect(response.header["x-duration"].to_s).to match(/(\d)$/)
    end
  end

  describe "search by city" do
    get 'venues/search/manchester'
    response = last_response

    it "should respond with venues matching the city" do
      jdata = JSON.parse(response.body)
      records = jdata["records"]

      records.each do |r|
        expect(r["city"]).to eql("Manchester")
      end
    end

    it "should response with code 200" do
      expect(response.status).to eql(200)
    end

    it "should respond with duration in header" do
      expect(response.header["x-duration"].to_s).to match(/(\d)$/)
    end
  end

  describe "no results" do
    get 'venues/search/something'
    response = last_response

    it "should respond with no results" do
      jdata = JSON.parse(response.body)
      expect(jdata).to match({ "duration" => /(\d)/, "records" => []})
    end

    it "should response with code 200" do
      expect(response.status).to eql(200)
    end

    it "should respond with duration in header" do
      expect(response.header["x-duration"].to_s).to match(/(\d)$/)
    end
  end
end
