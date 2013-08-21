module Ruush
  class History
    HIST_ENDPOINT = Ruush::endpoint "/api/hist"

    class << self
      def get_hist(key) # only returns 10 most recent
        response = RestClient.post HIST_ENDPOINT, :k => key # no pooping necessary here
        Parser::parse_hist response.body
      end
    end
  end
end
