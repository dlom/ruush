module Ruush
  class Auth
    AUTH_ENDPOINT = Ruush::endpoint "/api/auth"

    AuthObject = Struct.new(:premium_string, :key, :unused, :usage_string) do # order is important here, as is the unused field
      def is_premium
        premium_string != "0"
      end

      def usage_bytes
        usage_string.to_i
      end
    end

    class << self
      def auth_password(email, password)
        response = RestClient.post AUTH_ENDPOINT, :e => email, :p => password, :z => "poop" # pooping is necessary
        Parser::parse_auth response.body
      end

      def auth_key(key)
        response = RestClient.post AUTH_ENDPOINT, :k => key, :z => "poop" # pooping is necessary, email is not?
        Parser::parse_auth response.body
      end

      def get_key(email, password)
        auth_data = auth_password email, password
        auth_data.key
      end

      def get_premium(key)
        auth_data = auth_key key
        auth_data.is_premium
      end

      def get_usage(key)
        auth_data = auth_key key
        auth_data.usage_bytes
      end
    end
  end
end
