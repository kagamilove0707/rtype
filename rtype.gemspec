# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rtype/version'

Gem::Specification.new do |spec|
  spec.name          = "rtype"
  spec.version       = RType::VERSION
  spec.authors       = ["TSUKIKAGE Osana"]
  spec.email         = ["kagamilove0707@gmail.com"]
  spec.summary       = %q{a tiny type inferer}
  spec.description   = %q{RType is a tiny type inferer. It is written in Ruby.}
  spec.homepage      = "https://github.com/kagamilove0707/rtype"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.7"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec"
end
