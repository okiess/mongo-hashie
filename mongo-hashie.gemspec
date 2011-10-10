# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "mongo-hashie/version"

Gem::Specification.new do |s|
  s.name = "mongo-hashie"
  s.version = MongoHashie::VERSION
  s.homepage = "http://github.com/okiess/mongo-hashie"
  s.authors = ["Oliver Kiessler"]
  s.summary = "Simple MongoDB Object Wrapper based on Hashie"
  s.description = "Simple MongoDB Object Wrapper based on Hashie"
  s.email = "kiessler@inceedo.com"

  s.add_development_dependency "rspec"
  s.add_development_dependency "rcov"
  s.add_dependency "hashie"
  s.add_dependency "mongo"
  s.add_dependency "bson_ext"

  s.rdoc_options = ["--charset=UTF-8"]   
  s.files         = Dir.glob("lib/**/*") + %w(LICENSE README.rdoc Rakefile)
  s.test_files    = Dir.glob("spec/*")
  s.require_paths = ["lib"]
end

