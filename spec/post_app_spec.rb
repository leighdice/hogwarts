require_relative 'app_spec_helper'

describe "Post Requests" do

  describe "Post - new venue" do

    venue = standard_venue_json
    post('/venues/new', venue.to_json, standard_header)
    response = last_response

    it "should respond with status 201" do
      expect(response.status).to eql(201)
    end

    it "should respond with duration in body" do
      jdata = JSON.parse(response.body)
      expect(jdata["duration"]).to match(/(\d)$/)
    end
  end
end
