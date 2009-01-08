module Natter
  class Bot
    include Doodle::Core
    include Natter::Callback

    has :channels, :collect => :add_channel
    def channel(kind = :xmpp, &block)
      adaptor_name = kind.to_s.classify + "Channel"
      adaptor_class = Natter::Channel.const_get(adaptor_name)
      add_channel adaptor_class.new(self, &block)
    end

    has :history_store, :default => nil
    has :roster, :kind => Natter::Roster, :default => proc { Natter::Roster.new }

    # TODO: Have a supervisor over these threads in case one dies.
    def run
      channels.map { |channel| channel.start }
    end

    protected
    callback :presence_change
    callback :message_received

    def reply_to(message, text)
      say_to(message.sender, text)
    end

    def say_to(contact, text)
      roster[contact.id].channels.detect do |channel|
        channel.deliver(contact, text)
      end
    end
  end

  def bot(&block)
    Natter::Bot(&block).run.map { |thread| thread.join }
  end
  extend self
end