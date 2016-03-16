require_relative 'app_spec_helper'

describe "Redis" do

  describe "x-no-redis header" do

    id = "56e402521338596b67000030"
    get("/venues/#{id}", no_redis_header)
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
end
