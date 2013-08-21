require "ruush/version"

require "rest-client"

require "ruush/endpoint"
require "ruush/errors"
require "ruush/parser"
require "ruush/auth"
require "ruush/history"
require "ruush/upload"
require "ruush/delete"

require "ruush/config"

module Ruush
  @config_file = "#{Dir.home}/.ruush"
  @config = Config.new @config_file

  def self.config
    @config
  end

  def self.write_config
    @config.write "#{Dir.home}/.ruush"
  end
end
