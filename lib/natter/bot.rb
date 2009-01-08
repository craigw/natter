module Natter
  class Bot
    include Natter::Callback
    include Doodle::Core

    has :username, :kind => String
    has :password, :kind => String

    has :roster, :collect => { :contact => Natter::Contact }, :key => :jid
    has :history_store, :default => nil

    def run
      @jabber = Jabber::Simple.new username, password
      @jabber.status(:away, "No one here but us mice.")
      @jabber.deliver("craig@xeriom.net", "I woke up at #{Time.now}.")

      Thread.new(@jabber) do |client|
        loop do
          begin
            client.received_messages do |msg|
              contact = Natter::Contact(:jid => msg.from.to_s.strip)
              message = Natter::Message(:sender => contact, :body => msg.body)
              send(:message_received, message)
            end

            client.presence_updates do |update|
              jid, status, status_message = *update
              contact = Natter::Contact(
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
      end
    end

    protected
    callback :presence_change
    callback :message_received

    def reply_to(message, text)
      say_to(message.sender, text)
    end

    def say_to(contact, text)
      @jabber.deliver(contact.jid, text)
    end
  end

  def bot(&block)
    Natter::Bot(&block).run.join
  end
  extend self
end