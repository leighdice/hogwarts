require_relative 'app_spec_helper'

describe "Search" do

  describe "search by name" do
    get 'venues/search/wembley'
    response = last_response

    it "should respond with venue matching the name" do
      puts "TODO"
    end

    it "should response with code 200" do
      expect(response.status).to eql(200)
    end

    it "should respond with duration in header" do
      expect(response.header["x-duration"].to_s).to match(/(\d)$/)
    end
  end

  describe "search by address" do
    get 'venues/search/square'
    response = last_response

    it "should respond with venues matching the address" do
      puts "TODO"
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
      puts "TODO"
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
