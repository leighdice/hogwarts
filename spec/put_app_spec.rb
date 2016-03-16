require 'date'
require_relative 'app_spec_helper'

describe "Put Request" do

  describe "Invalid ID" do

    put('/venues/someInvalidID', updated_name_json.to_json, standard_header)
    response = last_response

    it "should respond with status 404" do
      expect(response.status).to eql(404)
    end

    it "should respond with body 404" do
      expect(response.body).to eql(not_found_with_id_error("someInvalidID"))
    end
  end

  describe "Invalid Paramater" do

    put('/venues/56e40252133859f813000027', updated_invalid_name_json.to_json, standard_header)
    response = last_response

    it "should respond with status 400" do
      expect(response.status).to eql(400)
    end

    it "should respond with correct error body" do
      expect(response.body).to eql(empty_param_error("name"))
    end
  end

  describe "Valid ID" do

    get '/venues/56e40252133859f813000027'
    old_response_body = JSON.parse(last_response.body)
    old_updated_at_string = old_response_body["records"].first["updated_at"]
    old_updated_at = Time.at(Time.parse(old_updated_at_string))

    put('/venues/56e40252133859f813000027', updated_name_json.to_json, standard_header)
    response = last_response

    it "should update paramater updated_at" do
      get '/venues/56e40252133859f813000027'
      new_response_body = JSON.parse(last_response.body)
      new_updated_at_string = new_response_body["records"].first["updated_at"]
      new_updated_at = Time.at(Time.parse(new_updated_at_string))

      expect(new_updated_at).to be > old_updated_at
    end

    it "should update the param" do
      get '/venues/56e40252133859f813000027'
      updated_param_body = JSON.parse(last_response.body)

      expect(updated_param_body["records"].first["name"]).to eql("Rspec Test")
    end

    it "should respond with status 204" do
      expect(response.status).to eql(204)
    end

    it "should respond with duration in the header" do
      expect(response.header["x-duration"].to_s).to match(/(\d)/)
    end
  end
end
