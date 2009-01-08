require File.dirname(__FILE__) + '/../init'
include Natter

bot do
  channel do
    username "user@domain.com"
    password "..."
  end
  on :message_received do |message|
    reply_to message, "I agree with you when you say ``#{message.body}''"
  end
end