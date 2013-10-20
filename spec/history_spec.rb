require "spec_helper"

describe "History" do
  let(:key) { "A1B2C3" }
  describe "endpoint" do
    it "should be /api/hist" do
      Ruush::Api::HIST_ENDPOINT.should eq "http://puush.me/api/hist"
    end
  end

  it "should get the 10 most recent history items" do
    stub = mock_history(key)

    result = Ruush::Api::get_hist key

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
