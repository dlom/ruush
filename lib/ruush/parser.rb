module Ruush
  class Parser
    AuthObject = Struct.new(:premium_string, :key, :unused, :usage_string) do # order is important here, as is the unused field
      def is_premium
        premium_string != "0"
      end

      def usage_bytes
        usage_string.to_i
      end
    end

    # /api/del returns the same object structure as /api/hist, so we don't need a new struct

    HistoryObject = Struct.new(:id, :time_string, :url, :filename, :view_count_string) do # order is important here
      def timestamp
        DateTime.parse time_string
      end

      def view_count
        view_count_string.to_i
      end
    end

    UploadObject = Struct.new(:url, :id, :usage_string) do # order is important here
      def usage_bytes
        usage_string.to_i
      end
    end

    class << self
      def parse_hist(body)
        hist_objects = []
        if body == "-1" # only (known) error code
          raise BadKey, "API Key is invalid"
        else
          body.split("0\n")[1..-1].each do |hist_data| # we have to split on "0\n", and the first element is always blank
            hist_objects.push HistoryObject.new *hist_data.split(",") # magic
          end
        end
        hist_objects
      end

      def parse_auth(body)
        if body == "-1" # only (known) error code
          raise BadAuth, "Credentials are invalid"
        end
        AuthObject.new *body.split(",")
      end

      def parse_upload(body)
        error_codes = {
          "-1" => [BadKey, "API Key is invalid"],
          "-2" => [BadData, "Data sent is invalid"],
          "-3" => [BadHash, "Data hash is invalid"]
          # "-?" => [Errors::QuotaExceded, "Quota exceded"] (needs more research)
        }
        upload_data = body.split ","
        if error_codes.has_key? upload_data[0] # account for multiple error codes
          raise error_codes[0], error_codes[1]
        end
        UploadObject.new *upload_data[1..-1] # first element is always "0"
      end
    end
  end
end
