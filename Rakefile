require 'bundler'
require 'rspec/core/rake_task'

$:.push File.expand_path("../lib", __FILE__)
require "mongo-hashie/version"

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |t|
    t.rcov = true
    t.rcov_opts = %w{--include lib -Ispec --exclude spec\,gems}
    t.rspec_opts = ["-c"]
end

task :default => :spec

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  version = MongoHashie::VERSION

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "mongo-hashie #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
