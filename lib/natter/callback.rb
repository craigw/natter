module Natter
  module Callback
    def self.included(base)
      base.class_eval do
        extend ClassMethods
        include InstanceMethods
      end
    end

    module ClassMethods
      def callback(*names)
        names.each do |name|
          class_eval <<-EOF, __FILE__, __LINE__ + 1
            def #{name}(*args)
              call_callbacks_for(#{name.to_sym.inspect}, *args)

              if history_store.respond_to?(#{name.to_sym.inspect})
                history_store.send(#{name.to_sym.inspect}, *args)
              end
            end
          EOF
        end
      end
      alias_method :callbacks, :callback
    end
    
    module InstanceMethods
      def on(event, &block)
        callbacks[event] ||= []
        callbacks[event] << block
      end

      private
      def call_callbacks_for(event, *args)
        callbacks_for(event).each do |callback|
          callback.call *args
        end
        nil # Don't leak return values
      end

      def callbacks_for(event)
        callbacks[event] || []
      end

      def callbacks
        @callbacks ||= {}
      end
      
    end
  end
end