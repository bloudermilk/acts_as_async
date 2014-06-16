module ActsAsAsync
  class Railtie < Rails::Railtie
    rake_tasks do
      require "resque/tasks"
      begin
        require "resque_scheduler/tasks"
      rescue LoadError
        require "resque/scheduler/tasks"
      end

      task "resque:setup" => :environment
    end
  end
end
