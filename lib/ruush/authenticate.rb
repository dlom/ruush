module Ruush
  class Auth
    AUTH_ENDPOINT = Ruush::endpoint "/api/auth"

    class << self
      def password_auth(email, password)
        response = RestClient.post AUTH_ENDPOINT, :e => email, :p => password, :z => "poop"
        Parser::parse_auth response.body
      end

      def key_auth(email, key)
        response = RestClient.post AUTH_ENDPOINT, :e => email, :k => key, :z => "poop"
        Parser::parse_auth response.body
      end

      def get_key(email, password)
        auth_data = password_auth email, password
        auth_data[:key]
      end

      def get_premium(email, key)
        auth_data = key_auth email, key
        auth_data[:is_premium]
      end

      def get_usage(email, key)
        auth_data = key_auth email, key
        auth_data[:usage_bytes]
      end
    end
  end
end
