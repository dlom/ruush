module Ruush
  class Api
    HIST_ENDPOINT = Ruush::endpoint "/api/hist"

    class << self
      def get_hist(key, number=10, offset=0)
        begin
          response = RestClient.post HIST_ENDPOINT, :k => key, :l => number, :o => offset # no pooping necessary here
        rescue RestClient::ServiceUnavailable
          return []
        end
        Parser::parse_hist response.body
      end
    end
  end
end
