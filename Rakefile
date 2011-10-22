require "bundler"
Bundler.setup

require "rake"
require "rspec"
require "rspec/core/rake_task"

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "acts_as_async/version"

RSpec::Core::RakeTask.new("spec")
task :default => :spec

task :build do
  system "gem build acts_as_async.gemspec"
end

task :install => :build do
  system "sudo gem install acts_as_async-#{ActsAsAsync::VERSION}.gem"
end
