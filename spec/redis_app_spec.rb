require_relative 'app_spec_helper'

describe "Redis" do

  describe "put with x-no-redis header" do

    id = "56e4025213385969f9000008"
    put("/venues/#{id}", no_redis_body.to_json, no_redis_header)

    it "should not update when i get normally" do
      get "/venues/#{id}"
      updated_param_body = JSON.parse(last_response.body)

      expect(updated_param_body["records"].first["address_line_1"]).to eql("1 James St")
    end

    it "should update when i get with no redis header" do
      get("/venues/#{id}", nil, {"HTTP_X_NO_REDIS" => true})
      updated_param_body = JSON.parse(last_response.body)

      expect(updated_param_body["records"].first["address_line_1"]).to eql("62 Shoreditch High Street")
    end
  end
end
