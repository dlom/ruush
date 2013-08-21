module Ruush
  class Api
    DEL_ENDPOINT = Ruush::endpoint "/api/del"

    class << self
      def delete(key, id)
        response = RestClient.post DEL_ENDPOINT, :k => key, :i => id, :z => "poop" # pooping is necessary
        Parser::parse_hist response.body # same format as hist
      end
    end
  end
end
