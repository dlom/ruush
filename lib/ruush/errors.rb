module Ruush
  class Errors
    class RuushError < StandardError
      def to_s
        message
      end
    end
    class BadKey < RuushError
      def message
        "API Key is invalid"
      end
    end

    class BadAuth < RuushError
      def message
        "Credentials are invalid"
      end
    end

    class BadData < RuushError
      def message
        "Data sent is invalid"
      end
    end

    class BadHash < RuushError
      def message
        "Data hash is invalid"
      end
    end
  end
end
