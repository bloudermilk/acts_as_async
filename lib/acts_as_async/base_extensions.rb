module ActsAsAsync
  module BaseExtensions
    extend ActiveSupport::Concern

    module ClassMethods
      def acts_as_async(opts={})
        # Make the default queue for this class "default"
        opts.reverse_merge!(queue: :default)

        # Set the queue unless one is already set
        unless instance_variable_defined?(:@queue)
          instance_variable_set(:@queue, opts[:queue])
        end

        include ActsAsAsync::Helper
      end
    end
  end
end

ActiveRecord::Base.send :include, ActsAsAsync::BaseExtensions
