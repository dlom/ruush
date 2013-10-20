module Ruush
  class Api
    HIST_ENDPOINT = Ruush::endpoint "/api/hist"

    class << self
      def get_hist(key) # only returns 10 most recent
        begin
          response = RestClient.post HIST_ENDPOINT, :k => key # no pooping necessary here
        rescue RestClient::ServiceUnavailable
          return []
        end
        Parser::parse_hist response.body
      end
    end
  end
end
