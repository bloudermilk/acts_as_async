require "active_support/concern"

require "active_record"

require "resque"

# Resque scheduler changed namespace, this probably isn't best way to support both old & new one but it's only way I can think of
begin
  require "resque_scheduler"
rescue
  require "resque-scheduler"
end

require "acts_as_async/errors"
require "acts_as_async/base_extensions"
require "acts_as_async/helper"
require "acts_as_async/version"

require "acts_as_async/railtie" if defined?(Rails)
