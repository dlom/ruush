module Ruush
  class History
    HIST_ENDPOINT = Ruush::endpoint "/api/hist"
    HistoryObject = Struct.new(:id, :time_string, :url, :filename, :view_count) do # order is important here
      def timestamp
        DateTime.parse time_string
      end
    end

    class << self
      def get_history(key) # only returns 10 most recent
        response = RestClient.post HIST_ENDPOINT, :k => key # no pooping here
        Parser::parse_hist response.body
      end
    end
  end
end
