module Ruush
  class Parser
    class << self
      def parse_hist(body)
        hist_objects = []
        if body == "-1" # only (known) error code
          raise BadKey, "API Key is invalid"
        else
          body.split("0\n")[1..-1].each do |hist_data| # we have to split on "0\n", and the first element is always blank
            hist_objects.push History::HistoryObject.new *hist_data.split(",") # magic
          end
        end
        hist_objects
      end

      def parse_auth(body)
        if body == "-1" # only (known) error code
          raise BadAuth, "Credentials are invalid"
        end
        Auth::AuthObject.new *body.split(",")
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
        Upload::UploadObject.new *upload_data[1..-1] # first element is always "0"
      end
    end
  end
end
