$LOAD_PATH.unshift "lib"

require "acts_as_async/version"

Gem::Specification.new do |s|
  s.name        = "acts_as_async"
  s.version     = ActsAsAsync::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Brendan Loudermilk"]
  s.email       = ["brendan@gophilosophie.com"]
  s.homepage    = "http://github.com/bloudermilk/acts_as_async"
  s.summary     = "The marriage of ActiveRecord and Resque"
  s.description = "ActsAsAsync is an ActiveRecord extension that provides your models with easy-to-use Resque helpers"

  # TODO: Find minimum versions
  s.add_dependency "resque"
  s.add_dependency "resque-scheduler"
  s.add_dependency "activesupport"
  s.add_dependency "activerecord"

  s.add_development_dependency "rspec", "~> 2.7.0"

  s.files         = Dir.glob("lib/**/*") + %w(LICENSE Rakefile README.md)
  s.require_path  = "lib"
end
