require_relative 'app_spec_helper'

describe "Post Requests" do

  describe "Post - new venue" do

    it "should respond with status 201" do
      venue = standard_venue_json
      post('/venues/new', venue.to_json, { "CONTENT_TYPE" => "application/json" })

      expect(last_response.status).to eql(201)
    end

    it "should respond with duration in body" do
      venue = standard_venue_json
      post('/venues/new', venue.to_json, { "CONTENT_TYPE" => "application/json" })
      jdata = JSON.parse(last_response.body)

      expect(jdata["duration"]).to match(/(\d)$/)
    end
  end
end
