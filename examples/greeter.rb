require File.dirname(__FILE__) + '/../init'
include Crib

bot do
  username "user@domain.com"
  password "..."
  on :presence_change do |contact|
    if contact.online?
      say_to contact, "Hey, how's tricks?"
    end
  end
end.run