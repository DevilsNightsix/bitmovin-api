Gem::Specification.new do |s|
  s.name          = 'bitmovin-api'
  s.version       = '0.0.0'
  s.date          = '2017-02-9'
  s.summary       = "Bitmovin api client"
  s.description   = "A simple hello world gem"
  s.authors       = ["DevilsNightsix"]
  s.email         = 'eeendi94@gmail.com'
  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.require_paths = ["lib"]
  s.homepage      = 'http://rubygems.org/gems/hola'
  s.license       = 'MIT'
end
