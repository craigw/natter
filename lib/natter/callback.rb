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
        conditional_callback_receivers = [ :history_store, :roster ]
        names.each do |name|
          class_eval <<-EOF, __FILE__, __LINE__ + 1
            def #{name}(*args)
              optional_callbacks_for(#{conditional_callback_receivers.inspect}, #{name.to_sym.inspect}, *args)
              call_callbacks_for(#{name.to_sym.inspect}, *args)
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
      def optional_callbacks_for(receivers, event, *args)
        receivers.each do |receiver_name|
          receiver = send(receiver_name)
          if receiver.respond_to?(event)
            receiver.send(event, *args)
            # FIXME: HACKY YUCK!
            # I do this because receiver !== self.{receiver_name}
            # They're different objects so any updates to receiver don't get
            # reflected in this class. :(
            send("#{receiver_name}=", receiver)
          end
        end
      end

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