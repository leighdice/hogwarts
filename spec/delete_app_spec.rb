require_relative 'app_spec_helper'

describe "Delete" do

  describe "Delete Valid ID" do

    id = "56e40252133859262d000021"
    delete "/venues/#{id}"
    response = last_response

    it "should respond with status 204" do
      expect(response.status).to eql(204)
    end

    it "should respond with duration in the header" do
      expect(response.header["x-duration"].to_s).to match(/(\d)$/)
    end

    it "should then be deleted" do
      get "/venues/#{id}"
      expect(last_response.body).to eql(not_found_with_id_error(id))
    end
  end

  describe "Delete Invalid ID" do

    delete '/venues/someInvalidID'
    response = last_response

    it "should respond with status 404" do
      expect(response.status).to eql(404)
    end

    it "should return correct body error" do
      expect(response.body).to eql(not_found_with_id_error("someInvalidID"))
    end
  end
end
