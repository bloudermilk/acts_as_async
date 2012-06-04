module ActsAsAsync
  module Helper
    extend ActiveSupport::Concern

    included do
      include SharedMethods
      extend SharedMethods
    end

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

        receiver.__send__(method, *args)
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

      def inherited(subclass)
        queue = instance_variable_get(:@queue)
        subclass.instance_variable_set(:@queue, queue)
        super
      end
    end

    def async(method, *args)
      raise MissingIDError unless id
      Resque.enqueue(self.class, id, method, *args)
    end

    def async_at(time, method, *args)
      raise MissingIDError unless id
      Resque.enqueue_at(time, self.class, id, method, *args)
    end

    def async_in(time, method, *args)
      raise MissingIDError unless id
      Resque.enqueue_in(time, self.class, id, method, *args)
    end

    module SharedMethods
      METHOD_REGEXP = /\Aasync_([a-zA-Z]\w*?)(_at|_in)?(!)?\z/

      def method_missing(method_id, *args, &block)
        if method_id.to_s =~ METHOD_REGEXP
          # Compose the method to be async'd, with an optional bang
          method = "#{$1}#{$3}"

          if respond_to? method, true
            # If we're not using the _at or _in methods, just call async
            if $2.nil?
              __send__(:async, method, *args)

            # Otherwise compose the Helper method
            else
              __send__("async#{$2}", args.shift, method, *args)
            end
          else
            message = "Tried to async the method #{method} but it isn't defined."
            raise NoMethodError, message
          end
        else
          super
        end
      end

      # Use respond_to_missing? on newer Ruby versions but fall back to
      # overriding respond_to? on older versions. In both cases, return
      # true for any match, even if the method to be async'd doesn't
      # exist, since technically we do respond to that method but throw
      # an exception.
      if RUBY_VERSION >= "1.9.2"
        def respond_to_missing?(method_id, *)
          !!(method_id =~ METHOD_REGEXP) || super
        end
      else
        def respond_to?(method_id, *)
          !!(method_id.to_s =~ METHOD_REGEXP) || super
        end
      end
    end
  end
end
