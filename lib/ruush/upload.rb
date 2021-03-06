require "digest"

module Ruush
  class Api
    UP_ENDPOINT = Ruush::endpoint "/api/up"

    class << self
      def upload_file(key, file) # will fail silently if upload is too big.
        raise ArgumentError, "#{file.inspect} is not a File object" if !file.is_a? File
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
