# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'canada_post/version'

Gem::Specification.new do |spec|
  spec.name          = "canada-post-api"
  spec.version       = CanadaPost::VERSION
  spec.authors       = ["JONBRWN"]
  spec.email         = ["jonathanbrown.a@gmail.com"]
  spec.summary       = %q{Canada Post API}
  spec.description   = %q{Ruby wrapper for the Canada Post API V3}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_dependency "httparty"
  spec.add_dependency "nokogiri"

  spec.add_development_dependency "bundler",  "~> 1.7"
  spec.add_development_dependency "rake",     "~> 10.0"
  # TESTING
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "webmock"
  spec.add_development_dependency "vcr"
end
