require_relative 'app_spec_helper'

describe "Version" do

  get '/version'
  response = last_response

  it "should respond with version number" do
    res = JSON.parse(response.body)
    expect(res["version"]).to eql("0.0.1")
  end

  it "should respond with duration in header" do
    expect(response.header["x-duration"].to_s).to match(/(\d)$/)
  end
end
