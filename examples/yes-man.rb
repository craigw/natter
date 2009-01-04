require File.dirname(__FILE__) + '/../init'
include Crib

bot do
  username "user@domain.com"
  password "..."
  on :message_received do |message|
    reply_to message, "I agree with you when you say ``#{message.body}''"
  end
end