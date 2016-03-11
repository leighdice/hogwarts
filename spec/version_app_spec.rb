require_relative 'app_spec_helper'

describe "Version" do

  it "should respond with version number" do
    get '/version'
    res = JSON.parse(last_response.body)
    expect(res["version"]).to eql("0.0.1")
  end

  it "should respond with duration in header" do
    get '/version'
    expect(last_response.header["x-duration"].to_s).to match(/(\d)$/)
  end
end
