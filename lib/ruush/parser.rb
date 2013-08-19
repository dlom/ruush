module Ruush
  class Parser
    class << self
      def parse_hist(body)
        hist_objects = []
        if body == "-1" # only (known) error code
          hist_failure = History::HistoryObject.new
          hist_failure.err = Errors::BadKey.new
          hist_objects.push hist_failure
        else
          body.split("0\n")[1..-1].each do |hist_data| # we have to split on "0\n", and the first element is always blank
            hist_objects.push History::HistoryObject.new *hist_data.split(",") # magic
          end
        end
        hist_objects
      end

      def parse_auth(body)
        if body == "-1" # only (known) error code
          auth_error = Auth::AuthObject.new
          auth_error.err = Errors::BadAuth.new
          return auth_error
        end
        Auth::AuthObject.new *body.split(",")
      end

      def parse_upload(body)
        error_codes = {
          "-1" => Errors::BadKey,
          "-2" => Errors::BadData,
          "-3" => Errors::BadHash
          # "-?" => Errors::QuotaExceded (needs more research)
        }
        upload_data = body.split ","
        if error_codes.has_key? upload_data[0] # account for multiple error codes
          upload_failure = Upload::UploadObject.new
          upload_failure.err = error_codes[upload_data[0]].new
          return upload_failure
        end
        Upload::UploadObject.new *upload_data[1..-1] # first element is always "0"
      end
    end
  end
end
