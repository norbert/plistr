require File.expand_path('../lib/plistr/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Norbert Crombach"]
  gem.email         = ["norbert.crombach@primetheory.org"]
  gem.summary       = %q{Fast XML property list reader.}
  gem.homepage      = "https://github.com/norbert/plistr"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "plistr"
  gem.require_paths = ["lib"]
  gem.version       = Plistr::VERSION

  gem.add_dependency 'nokogiri'
  gem.add_development_dependency 'rake'
end
