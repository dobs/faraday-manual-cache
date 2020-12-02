# coding: utf-8
$:.push File.expand_path("../lib", __FILE__)
require 'faraday-manual-cache/version'

Gem::Specification.new do |spec|
  spec.name          = 'faraday-manual-cache'
  spec.version       = FaradayManualCache::VERSION
  spec.authors       = ['Daniel O\'Brien']
  spec.email         = ['dan@dobs.org']
  spec.summary       = %q(A super simple Faraday cache implementation.)
  spec.description   = %q(A super simple Faraday cache implementation.)
  spec.homepage      = 'https://github.com/dobs/faraday-manual-cache'
  spec.license       = 'MIT'

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(/^bin\//) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(/^(test|spec|features)\//)
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 1.9'

  spec.add_dependency 'activesupport', '>= 3.0.0'
  spec.add_dependency 'faraday', '>= 0.9'

  spec.add_development_dependency 'bundler', '>= 1.5'
  spec.add_development_dependency 'rake'
  spec.add_development_dependency 'rspec'
end
