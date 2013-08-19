module Ruush
  class Delete
    DEL_ENDPOINT = Ruush::endpoint "/api/del"
    # /api/del returns the same object structure as /api/hist, so we don't need a new struct

    class << self
      def delete(key, id)
        response = RestClient.post DEL_ENDPOINT, :k => key, :i => id, :z => "poop" # pooping is necessary
        Parser::parse_hist response.body # same format as hist
      end
    end
  end
end
