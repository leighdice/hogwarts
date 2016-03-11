require_relative 'app_spec_helper'

describe "Post Requests" do

  describe "Post Invalid Data" do

    describe "Post empty params" do

      base_empty_json = {
        "address_line_1" => "Richmond Building",
        "address_line_2" => "University of Bristol Students' Union",
        "address_line_3" => "105 Queens Rd",
        "city" => "Bristol",
        "country" => "United Kingdom",
        "county" => "",
        "name" => "Anson Rooms",
        "postcode" => "BS8 1LN"}

      describe "Post empty name" do

        it "should respond with status 400" do
          wo_name = base_empty_json
          wo_name["name"] = ""
          post('/venues/new', wo_name.to_json, { "CONTENT_TYPE" => "application/json" })

          expect(last_response.status).to eql(400)
        end

        it "should respond with correct error body" do
          wo_name = base_empty_json
          wo_name["name"] = ""
          post('/venues/new', wo_name.to_json, { "CONTENT_TYPE" => "application/json" })
          expect(last_response.body).to eql({ :error => "Validation Error",
                                              :code  => 400,
                                              :description => "Bad Request",
                                              :messages => { "name":["name cannot be empty"]}}.to_json)
        end
      end

      describe "Post empty address_line_1" do
        it "should respond with status 400" do
          wo_a_l_1 = base_empty_json
          wo_a_l_1["address_line_1"] = ""
          post('/venues/new', wo_a_l_1.to_json, { "CONTENT_TYPE" => "application/json" })

          expect(last_response.status).to eql(400)
        end

        it "should respond with correct error body" do
          wo_a_l_1 = base_empty_json
          wo_a_l_1["address_line_1"] = ""
          post('/venues/new', wo_a_l_1.to_json, { "CONTENT_TYPE" => "application/json" })
          expect(last_response.body).to eql({ :error => "Validation Error",
                                              :code  => 400,
                                              :description => "Bad Request",
                                              :messages => { "address_line_1":["address_line_1 cannot be empty"]}}.to_json)
        end
      end

      describe "Post empty city" do
        it "should respond with status 400" do
          wo_city = base_empty_json
          wo_city["city"] = ""
          post('/venues/new', wo_city.to_json, { "CONTENT_TYPE" => "application/json" })

          expect(last_response.status).to eql(400)
        end

        it "should respond with correct error body" do
          wo_city = base_empty_json
          wo_city["city"] = ""
          post('/venues/new', wo_city.to_json, { "CONTENT_TYPE" => "application/json" })
          expect(last_response.body).to eql({ :error => "Validation Error",
                                              :code  => 400,
                                              :description => "Bad Request",
                                              :messages => { "city":["name cannot be empty"]}}.to_json)
        end
      end

      describe "Post empty country" do
        it "should respond with status 400" do
          wo_country = base_empty_json
          wo_country["country"] = ""
          post('/venues/new', wo_country.to_json, { "CONTENT_TYPE" => "application/json" })

          expect(last_response.status).to eql(400)
        end

        it "should respond with correct error body" do
          wo_country = base_empty_json
          wo_country["country"] = ""
          post('/venues/new', wo_country.to_json, { "CONTENT_TYPE" => "application/json" })
          expect(last_response.body).to eql({ :error => "Validation Error",
                                              :code  => 400,
                                              :description => "Bad Request",
                                              :messages => { "country":["country cannot be empty"]}}.to_json)
        end
      end

      describe "Post empty postcode" do
        it "should respond with status 400" do
          wo_postcode = base_empty_json
          wo_postcode["postcode"] = ""
          post('/venues/new', wo_postcode.to_json, { "CONTENT_TYPE" => "application/json" })

          expect(last_response.status).to eql(400)
        end

        it "should respond with correct error body" do
          wo_postcode = base_empty_json
          wo_postcode["postcode"] = ""
          post('/venues/new', wo_postcode.to_json, { "CONTENT_TYPE" => "application/json" })
          expect(last_response.body).to eql({ :error => "Validation Error",
                                              :code  => 400,
                                              :description => "Bad Request",
                                              :messages => { "postcode":["postcode cannot be empty"]}}.to_json)
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
