module Ruush
  BASE_URL = "http://puush.me"
  def self.endpoint(endpoint)
    "#{BASE_URL}#{endpoint}"
  end
end
