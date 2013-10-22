require "spec_helper"

describe "Authentication" do
  let(:email) { "example@example.com" }
  let(:password) { "verysecurepassword123" }
  let(:key) { "A1B2C3" }

  describe "endpoint" do
    it "should be /api/auth" do
      Ruush::Api::AUTH_ENDPOINT.should eq "http://puush.me/api/auth"
    end
  end

  describe "password auth" do
    it "should retrieve the correct information" do
      stub = mock_password_auth(email, password, key, true, 10000)

      result = Ruush::Api::auth_password email, password

      result.key.should eq key
      result.expiry.should eq ""
      result.is_premium.should eq true
      result.usage_bytes.should eq 10000
      stub.should have_been_requested
    end
  end

  describe "key auth" do
    it "should retrieve the correct information" do
      stub = mock_key_auth(key, false, 100)

      result = Ruush::Api::auth_key key

      result.key.should eq key
      result.expiry.should eq ""
      result.is_premium.should eq false
      result.usage_bytes.should eq 100
      stub.should have_been_requested
    end
  end

  describe "getting specifics" do
    it "should get the key" do
      stub = mock_password_auth(email, password, key, false, 100)

      result = Ruush::Api::get_key email, password

      result.should eq key
      stub.should have_been_requested
    end

    it "should get premium status" do
      stub = mock_key_auth(key, true, 100)

      result = Ruush::Api::get_premium key

      result.should eq true
      stub.should have_been_requested
    end

    it "should get the usage in bytes" do
      stub = mock_key_auth(key, false, 12345678)

      result = Ruush::Api::get_usage key

      result.should eq 12345678
      stub.should have_been_requested
    end
  end
end
