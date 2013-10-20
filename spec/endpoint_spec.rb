require "spec_helper"

describe "Endpoint" do
  it "should have the correct base url" do
    Ruush::BASE_URL.should eq "http://puush.me"
  end

  it "should concatenate the base url with the endpoint" do
    Ruush::endpoint("/api/auth").should eq "#{Ruush::BASE_URL}/api/auth"
    Ruush::endpoint("/api/del").should eq "#{Ruush::BASE_URL}/api/del"
    Ruush::endpoint("/api/hist").should eq "#{Ruush::BASE_URL}/api/hist"
    Ruush::endpoint("/api/up").should eq "#{Ruush::BASE_URL}/api/up"
  end
end
