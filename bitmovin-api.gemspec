require File.expand_path('../lib/bitmovin/version', __FILE__)

Gem::Specification.new do |s|
  s.name          = 'bitmovin-api'
  s.version       = Bitmovin::VERSION
  s.date          = '2017-02-09'
  s.summary       = "Bitmovin api client"
  s.description   = "Simple ruby wrapper for bitmovin encoding service api. Written in pure ruby with no runtime dependencies."
  s.authors       = ["DevilsNightsix"]
  s.email         = 'eeendi94@gmail.com'
  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.require_paths = ["lib"]
  s.homepage      = 'http://rubygems.org/gems/bitmovin-api'
  s.license       = 'MIT'
  s.add_development_dependency "yard"
  s.add_development_dependency "rake"
  s.add_development_dependency "byebug"
  s.add_development_dependency "guard"
  s.add_development_dependency "guard-minitest"
  s.add_development_dependency "apib-mock_server"
  s.add_development_dependency "webmock"
  s.add_development_dependency "minitest-color"
end
