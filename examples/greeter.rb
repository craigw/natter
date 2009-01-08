require File.dirname(__FILE__) + '/../init'
include Natter

bot do
  channel do
    username "..."
    password "..."
  end
  on :presence_change do |contact|
    if contact.online?
      say_to contact, "Hey, how's tricks?"
    end
  end
end