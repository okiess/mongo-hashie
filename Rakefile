require 'bundler'
require 'rspec/core/rake_task'

Bundler::GemHelper.install_tasks

RSpec::Core::RakeTask.new(:spec)

RSpec::Core::RakeTask.new(:rcov) do |t|
    t.rcov = true
    t.rcov_opts = %w{--include lib -Ispec --exclude spec\,gems}
    t.spec_opts = ["-c"]
end

task :default => :spec