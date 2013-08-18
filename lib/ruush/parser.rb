module Ruush
  class Parser
    class << self
      def parse_hist(body)
        hist_objects = []
        if body == "-1" # FAILURE SOMEHOW
          hist_objects.push History::HistoryObject.new -1, "1970-1-1 00:00:00", "", "", 0
        else # else success (we hope)
          body.split("0\n")[1..-1].each do |hist_data| # we have to split on "0\n", and the first element is always blank
            hist_objects.push History::HistoryObject.new *hist_data.split(",") # magic
          end
        end
        hist_objects
      end

      def parse_auth(body)
        if body == "-1" # FAILURE SOMEHOW
          return {
            :key         => "",
            :is_premium  => false,
            :usage_bytes => 0
          }
        end # else success (we hope)
        auth_data = body.split ","
        {
          :key         => auth_data[1],
          :is_premium  => auth_data[0] != "0",
          :usage_bytes => auth_data[3].to_i
        }
      end
    end
  end
end
