require_relative 'app_spec_helper'

describe "Delete" do

  describe "Delete Valid ID" do

  end

  describe "Delete Invalid ID" do

    it "should respond with status 404" do
      delete '/venues/123'
      expect(last_response.status).to eql(404)
    end

    it "should return correct body error" do
      delete '/venues/123'
      expect(last_response.body).to eql(not_found_with_id_error("123"))
    end
  end
end
