require_relative 'app_spec_helper'

describe "Version" do

  it "should respond with version number" do
    get '/version'
    res = JSON.parse(last_response.body)
    expect(res["version"]).to eql("0.0.1")
  end
end
