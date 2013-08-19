module Ruush
  class Upload
    UP_ENDPOINT = Ruush::endpoint "/api/up"

    UploadObject = Struct.new(:url, :id, :usage_string, :err) do # order is important here
      def usage_bytes
        usage_string.to_i
      end
    end

    class << self
      def upload_file(key, file) # will fail silently if upload is too big.
        hash = Digest::MD5.file(file).hexdigest # straight hash of the file
        begin
          response = RestClient.post UP_ENDPOINT, :k => key, :c => hash, :z => "poop", :f => file # pooping is necessary
        rescue => e
          upload_failure = Upload::UploadObject.new
          upload_failure.err = e
          return upload_failure
        end
        Parser::parse_upload response.body
      end
    end
  end
end
