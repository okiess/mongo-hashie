# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "mongo-hashie"
  s.version = "0.1.1"
  s.homepage = "http://github.com/okiess/mongo-hashie"
  s.authors = ["Oliver Kiessler"]
  s.summary = "Simple MongoDB Object Wrapper based on Hashie"
  s.description = "Simple MongoDB Object Wrapper based on Hashie"
  s.email = "kiessler@inceedo.com"

  s.add_development_dependency "rspec"
  s.add_dependency "hashie"
  s.add_dependency "mongo"
  s.add_dependency "bson_ext"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- spec/*`.split("\n")
  s.require_paths = ["lib"]
end

