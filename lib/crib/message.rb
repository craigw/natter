module Crib
  class Message
    include Doodle::Core
    has :sender, :kind => Crib::Contact
    has :recipient, :kind => Crib::Contact, :default => proc { Crib::Contact(:jid => "bot") }
    has :body, :kind => String

    def reply(text)
      Crib::Message(
        :sender => Crib::Contact(:jid => "bot"),
        :recipient => sender,
        :body => text
      )
    end
  end
end