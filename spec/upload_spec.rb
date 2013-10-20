require "spec_helper"

describe "Upload" do
  let(:key) { "A1B2C3" }
  describe "endpoint" do
    it "should be /api/up" do
      Ruush::Api::UP_ENDPOINT.should eq "http://puush.me/api/up"
    end
  end

  it "should upload a file" do
    # TODO webmock can't handle uploads
  end
end
