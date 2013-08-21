module Ruush
  class Errors
    class Error < StandardError
      def to_s
        message
      end
    end
    class BadKey < Error
      def message
        "API Key is invalid"
      end
    end

    class BadAuth < Error
      def message
        "Credentials are invalid"
      end
    end

    class BadData < Error
      def message
        "Data sent is invalid"
      end
    end

    class BadHash < Error
      def message
        "Data hash is invalid"
      end
    end
  end
end
