$LOAD_PATH.unshift 'lib'
require 'acts_as_async/version'

Gem::Specification.new do |s|
  s.name              = "acts_as_async"
  s.version           = ActsAsAsync::VERSION
  s.date              = Time.now.strftime('%Y-%m-%d')
  s.summary           = "Acts As Async is a Resque-backed ActiveRecord delayed job tool"
  s.homepage          = "http://github.com/bloudermilk/acts_as_async"
  s.email             = "brendan@gophilosophie.com"
  s.authors           = [ "Brendan Loudermilk" ]

  s.files             = %w( README.md Rakefile LICENSE HISTORY.md )
  s.files            += Dir.glob("lib/**/*")

  s.extra_rdoc_files  = [ "LICENSE", "README.md" ]
  s.rdoc_options      = ["--charset=UTF-8"]

  # TODO: Find minimum versions
  s.add_dependency "resque"
  s.add_dependency "resque-scheduler"
  s.add_dependency "activerecord"

  s.description = <<description
    This gem is so crazy you won't believe.
description
end
