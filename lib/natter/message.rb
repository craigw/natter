module Natter
  class Message
    include Doodle::Core
    has :sender, :kind => Natter::Contact
    has :recipient, :kind => Natter::Contact, :default => proc { Natter::Contact(:jid => "bot") }
    has :body, :kind => String
    has :received_at, :kind => Time, :default => proc { Time.now }

    def reply(text)
      Natter::Message(
        :sender => Natter::Contact(:jid => "bot"),
        :recipient => sender,
        :body => text
      )
    end
  end
end