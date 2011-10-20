module ActsAsAsync
  module Helper
    extend ActiveSupport::Concern

    module ClassMethods
      # Args will be an optional ID, a method name and optional arguments
      def perform(*args)
        # Class methods
        if args.first.is_a? String
          receiver = self
          method = args.shift

        # Instance methods
        else
          id = args.shift
          receiver = find(id)
          method = args.shift
        end

        receiver.send(method, *args)
      end

      def async(method, *args)
        Resque.enqueue(self, method, *args)
      end

      def async_at(time, method, *args)
        Resque.enqueue_at(time, self, method, *args)
      end

      def async_in(time, method, *args)
        Resque.enqueue_in(time, self, method, *args)
      end
    end

    module InstanceMethods
      def async(method, *args)
        Resque.enqueue(self.class, id, method, *args)
      end

      def async_at(time, method, *args)
        Resque.enqueue_at(time, self.class, id, method, *args)
      end

      def async_in(time, method, *args)
        Resque.enqueue_in(time, self.class, id, method, *args)
      end
    end
  end
end
