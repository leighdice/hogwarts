require_relative 'app_spec_helper'

describe "Get Requests" do

  describe "Get by ID" do

    it "should return venue json" do

    end

    it "should response with code 200" do

    end
  end

  describe "Get invalid id" do

    it "should respond with 404" do
      get '/venues/123'
      expect(last_response.status).to eql(404)
    end

    it "should return body error" do
      get '/venues/123'
      jdata = last_response.body
      expect(jdata).to eql({ :error => "Unable to find venue",
                              :code  => 404,
                              :description => "Not found",
                              :messages => ["Unable to find venue by id: 123"]}.to_json)
    end
  end

  describe "Get all venues" do

    it "should return array of venues" do

    end

    it "should respond with 200" do

    end
  end

  describe "Get invalid url" do

    it "should respond with status 404" do
      get '/vnue'
      expect(last_response.status).to eql(404)
    end

    it "should respond with default not found body" do
      get '/vnue'
      jdata = last_response.body
      expect(jdata).to eql({ :error => "These are not the links you're looking for",
                              :code => 404,
                              :description => "Not found",
                              :messages => ["The url you requested is invalid"]}.to_json)
    end
  end
end
