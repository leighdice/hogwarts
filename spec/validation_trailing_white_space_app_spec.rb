require_relative 'app_spec_helper'

describe "Validation" do

  describe "Post Trailing White Space Parameters" do

    describe "Post param with pre white space" do

      venue = standard_venue_json
      venue["name"] = add_pre_white_space(venue["name"])
      post('/venues/new', venue.to_json, standard_header)
      response = last_response

      it "should respond with the status 400" do
        expect(response.status).to eql(400)
      end

      it "should respond with the correct error body" do
        expect(response.body).to eql(trailing_white_space_error("name"))
      end
    end

    describe "Post param with post white space" do

      venue = standard_venue_json
      venue["name"] = add_post_white_space(venue["name"])
      post('/venues/new', venue.to_json, standard_header)
      response = last_response

      it "should respond with the status 400" do
        expect(response.status).to eql(400)
      end

      it "should respond with the correct error body" do
        expect(response.body).to eql(trailing_white_space_error("name"))
      end
    end

    describe "Post param with pre and post white space" do

      venue = standard_venue_json
      venue["name"] = add_pre_and_post_white_space(venue["name"])
      post('/venues/new', venue.to_json, standard_header)
      response = last_response

      it "should respond with the status 400" do
        expect(response.status).to eql(400)
      end

      it "should respond with the correct error body" do
        expect(response.body).to eql(trailing_white_space_error("name"))
      end
    end
  end
end
