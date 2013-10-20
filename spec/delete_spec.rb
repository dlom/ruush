require "spec_helper"

describe "Delete" do
  let(:key) { "A1B2C3" }
  describe "endpoint" do
    it "should be /api/del" do
      Ruush::Api::DEL_ENDPOINT.should eq "http://puush.me/api/del"
    end
  end

  it "should get the 10 most recent history items" do
    stub = mock_delete(key, "3")

    result = Ruush::Api::delete key, "3"

    result.length.should eq 10
    10.times do |i|
      result[i].id.should eq "#{i}"
      result[i].time_string.should eq "1970-#{i}-1 12:34:56"
      result[i].url.should eq "http://puu.sh/#{i}.png"
      result[i].filename.should eq "#{i}.gif"
      result[i].view_count.should eq i
    end
  end
end
