# Load up the test environment
Bundler.setup(:default, :test)
Bundler.require(:default, :test)

lib_path = File.expand_path("../../lib", __FILE__)
$LOAD_PATH.unshift lib_path unless $LOAD_PATH.include? lib_path

require "acts_as_async"

ActiveRecord::Base.establish_connection({
  :adapter => RUBY_PLATFORM == "java" ? "jdbcsqlite3" : "sqlite3",
  :database => ":memory:"
})

ActiveRecord::Base.silence do
  ActiveRecord::Migration.verbose = false

  load(File.expand_path "../schema.rb", __FILE__)
  load(File.expand_path "../models.rb", __FILE__)
end

RSpec.configure do |config|
  config.mock_with :rspec

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation
    DatabaseCleaner.clean
  end

  config.after(:each) do
    DatabaseCleaner.clean
  end
end
