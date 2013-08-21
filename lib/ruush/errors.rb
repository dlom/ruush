module Ruush
  class Error < StandardError; end
  class BadKey < Error; end
  class BadAuth < Error; end
  class BadData < Error; end
  class BadHash < Error; end
end
