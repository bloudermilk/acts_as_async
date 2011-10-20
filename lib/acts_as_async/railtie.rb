module ActsAsAsync
  class Railtie < Rails::Railtie
    rake_tasks do
      require "resque/tasks"
      require "resque_scheduler/tasks"

      task "resque:setup" => :environment
    end
  end
end
