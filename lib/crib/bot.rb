module Crib
  class Bot
    include Doodle::Core

    has :username, :kind => String
    has :password, :kind => String

    def on(event, &block)
      callbacks[event] ||= []
      callbacks[event] << block
    end

    def run
      @jabber = Jabber::Simple.new username, password
      @jabber.status(:away, "No one here but us mice.")
      @jabber.deliver("craig@xeriom.net", "I woke up at #{Time.now}.")

      Thread.new(@jabber) do |client|
        loop do # Presence
          begin
            client.received_messages do |msg|
              contact = Crib::Contact(:jid => msg.from.to_s.strip)
              message = Crib::Message(:sender => contact, :body => msg.body)
              send(:message_received, message)
            end

            client.presence_updates do |update|
              jid, status, status_message = *update
              contact = Crib::Contact(
                :jid => jid,
                :status => status,
                :status_message => status_message
              )
              send(:presence_change, contact)
            end
          rescue => bang
            puts bang.inspect
          end
          sleep 0.1
        end
      end.join
    end

    protected
    def presence_change(contact)
      call_callbacks_for(:presence_change, contact)
    end

    def message_received(message)
      call_callbacks_for(:message_received, message)
    end

    def reply_to(message, text)
      say_to(message.sender, text)
    end

    def say_to(contact, text)
      @jabber.deliver(contact.jid, text)
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

  def bot(&block)
    Crib::Bot(&block)
  end
end