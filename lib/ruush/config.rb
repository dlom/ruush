require "settingslogic"

module Ruush
  class Config < Settingslogic
    DEFAULTS = {
      "key" => "",
      "email" => "",
      "is_premium" => false,
      "usage_bytes" => -1
    }

    def initialize(filename, section = nil)
      if !File.exists? filename
        write_defaults filename
      end
      super
    end

    def write(filename)
      File.open filename, "w" do |f|
        f.write self.to_h.to_yaml
      end
    end

    def write_defaults(filename)
      File.open filename, "w" do |f|
        f.write DEFAULTS.to_yaml
      end
    end
  end
end
