module Ruush
  class Auth
    class << self
      AUTH_ENDPOINT = Ruush.endpoint "/api/auth"

      def parse_auth(body)
        if body == "-1" # FAILURE SOMEHOW
          return {
            :key  => "",
            :is_premium  => false,
            :usage_bytes => 0
          }
        end # else success (we hope)
        auth_data = body.split ","
        {
          :key  => auth_data[1],
          :is_premium  => auth_data[0] != "0",
          :usage_bytes => auth_data[3].to_i
        }
      end

      def password_auth(email, password)
        response = RestClient.post AUTH_ENDPOINT, :e => email, :p => password, :z => "poop"
        parse_auth response.body
      end

      def key_auth(email, key)
        response = RestClient.post AUTH_ENDPOINT, :e => email, :k => key, :z => "poop"
        parse_auth response.body
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
