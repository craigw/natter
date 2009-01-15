module Natter
  module Channel
    class XmppChannel
      include Doodle::Core

      has :controller, :kind => Natter::Bot
      has :username, :kind => String
      has :password, :kind => String
      has :default_status, :default => :away
      has :default_status_message, :default => "No one here but us mice."

      def deliver(contact, text)
        @jabber.deliver(contact.jid, text)
      end

      def start
        @jabber = Jabber::Simple.new username, password
        @jabber.status(default_status, default_status_message)

        Thread.new(@jabber) do |client|
          loop do
            begin
              client.received_messages do |msg|
                contact = Natter::Contact(:jid => msg.from.to_s.strip.split(/\//, 2)[0])
                message = Natter::Message(:sender => contact, :body => msg.body)
                controller.send(:message_received, message)
              end

              client.presence_updates do |update|
                jid, status, status_message = *update
                contact = Natter::Contact(
                  :jid => jid.to_s.strip.split(/\//, 2)[0],
                  :status => status,
                  :status_message => status_message
                )
                controller.send(:presence_change, contact)
              end
            rescue => bang
              puts bang.inspect
            end
            sleep 0.1
          end
        end
      end
    end
  end
end