module Ruush
  class History
    HIST_ENDPOINT = Ruush::endpoint "/api/hist"

    HistoryObject = Struct.new(:id, :time_string, :url, :filename, :view_count_string, :err) do # order is important here
      def timestamp
        DateTime.parse time_string
      end

      def view_count
        view_count_string.to_i
      end
    end

    class << self
      def get_hist(key) # only returns 10 most recent
        response = RestClient.post HIST_ENDPOINT, :k => key # no pooping necessary here
        Parser::parse_hist response.body
      end
    end
  end
end
