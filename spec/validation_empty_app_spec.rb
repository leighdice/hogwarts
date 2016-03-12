require_relative 'app_spec_helper'

describe "Validation" do

  describe "Post Empty Parameters" do

    describe "Post empty name" do

      wo_name = venue_with_empty_param("name")
      post('/venues/new', wo_name.to_json, { "CONTENT_TYPE" => "application/json" })
      response = last_response

      it "should respond with status 400" do
        expect(response.status).to eql(400)
      end

      it "should respond with correct error body" do
        expect(response.body).to eql(empty_param_error("name"))
      end
    end

    describe "Post empty address_line_1" do

      wo_a_l_1 = venue_with_empty_param("address_line_1")
      post('/venues/new', wo_a_l_1.to_json, { "CONTENT_TYPE" => "application/json" })
      response = last_response

      it "should respond with status 400" do
        expect(response.status).to eql(400)
      end

      it "should respond with correct error body" do
        expect(response.body).to eql(empty_param_error("address_line_1"))
      end
    end

    describe "Post empty city" do
      
      wo_city = venue_with_empty_param("city")
      post('/venues/new', wo_city.to_json, { "CONTENT_TYPE" => "application/json" })
      response = last_response

      it "should respond with status 400" do
        expect(response.status).to eql(400)
      end

      it "should respond with correct error body" do
        expect(response.body).to eql(empty_param_error("city"))
      end
    end

    describe "Post empty country" do

      wo_country = venue_with_empty_param("country")
      post('/venues/new', wo_country.to_json, { "CONTENT_TYPE" => "application/json" })
      response = last_response

      it "should respond with status 400" do
        expect(response.status).to eql(400)
      end

      it "should respond with correct error body" do
        expect(response.body).to eql(empty_param_error("country"))
      end
    end

    describe "Post empty postcode" do

      wo_postcode = venue_with_empty_param("postcode")
      post('/venues/new', wo_postcode.to_json, { "CONTENT_TYPE" => "application/json" })
      response = last_response

      it "should respond with status 400" do
        expect(response.status).to eql(400)
      end

      it "should respond with correct error body" do
        expect(response.body).to eql(empty_param_error("postcode"))
      end
    end
  end
end
