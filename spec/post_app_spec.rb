require_relative 'app_spec_helper'

describe "Post Requests" do

  describe "Post Invalid Data" do

    describe "Post empty params" do

      describe "Post empty name" do

        it "should respond with status 400" do
          wo_name = venue_with_empty_param("name")
          post('/venues/new', wo_name.to_json, { "CONTENT_TYPE" => "application/json" })

          expect(last_response.status).to eql(400)
        end

        it "should respond with correct error body" do
          wo_name = venue_with_empty_param("name")
          post('/venues/new', wo_name.to_json, { "CONTENT_TYPE" => "application/json" })
          expect(last_response.body).to eql(empty_param_error("name"))
        end
      end

      describe "Post empty address_line_1" do
        it "should respond with status 400" do
          wo_a_l_1 = venue_with_empty_param("address_line_1")
          post('/venues/new', wo_a_l_1.to_json, { "CONTENT_TYPE" => "application/json" })

          expect(last_response.status).to eql(400)
        end

        it "should respond with correct error body" do
          wo_a_l_1 = venue_with_empty_param("address_line_1")
          post('/venues/new', wo_a_l_1.to_json, { "CONTENT_TYPE" => "application/json" })
          expect(last_response.body).to eql(empty_param_error("address_line_1"))
        end
      end

      describe "Post empty city" do
        it "should respond with status 400" do
          wo_city = venue_with_empty_param("city")
          post('/venues/new', wo_city.to_json, { "CONTENT_TYPE" => "application/json" })

          expect(last_response.status).to eql(400)
        end

        it "should respond with correct error body" do
          wo_city = venue_with_empty_param("city")
          post('/venues/new', wo_city.to_json, { "CONTENT_TYPE" => "application/json" })
          expect(last_response.body).to eql(empty_param_error("city"))
        end
      end

      describe "Post empty country" do
        it "should respond with status 400" do
          wo_country = venue_with_empty_param("country")
          post('/venues/new', wo_country.to_json, { "CONTENT_TYPE" => "application/json" })

          expect(last_response.status).to eql(400)
        end

        it "should respond with correct error body" do
          wo_country = venue_with_empty_param("country")
          post('/venues/new', wo_country.to_json, { "CONTENT_TYPE" => "application/json" })
          expect(last_response.body).to eql(empty_param_error("country"))
        end
      end

      describe "Post empty postcode" do
        it "should respond with status 400" do
          wo_postcode = venue_with_empty_param("postcode")
          post('/venues/new', wo_postcode.to_json, { "CONTENT_TYPE" => "application/json" })

          expect(last_response.status).to eql(400)
        end

        it "should respond with correct error body" do
          wo_postcode = venue_with_empty_param("postcode")
          post('/venues/new', wo_postcode.to_json, { "CONTENT_TYPE" => "application/json" })
          expect(last_response.body).to eql(empty_param_error("postcode"))
        end
      end
    end

    describe "Post params with trailing white space" do

      describe "Post param with pre white space" do

      end

      describe "Post param with post white space" do

      end

      describe "Post param with pre and post white space" do

      end
    end
  end
end
