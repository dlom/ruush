# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'ruush/version'

Gem::Specification.new do |spec|
  spec.name          = "ruush"
  spec.version       = Ruush::VERSION
  spec.authors       = ["Mark Old"]
  spec.email         = ["dlom234@gmail.com"]
  spec.description   = %q{puush client in ruby}
  spec.summary       = %q{Command-line access to puush via ruby}
  spec.homepage      = "https://github.com/Dlom/ruush"
  spec.license       = "MIT"

  spec.required_ruby_version = ">= 2.0.0"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "rest-client"
  spec.add_dependency "slop"
  spec.add_dependency "settingslogic"

  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
end
