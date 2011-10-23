module ActsAsAsync
  module BaseExtensions
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_async(opts={})
        # Set the queue to the passed option
        if opts[:queue]
          instance_variable_set(:@queue, opts[:queue])
        # If no option was passed and there isn't a queue defined, use "default"
        elsif !instance_variable_defined?(:@queue)
          instance_variable_set(:@queue, :default)
        end

        include ActsAsAsync::Helper
      end
    end
  end
end

ActiveRecord::Base.send :include, ActsAsAsync::BaseExtensions
