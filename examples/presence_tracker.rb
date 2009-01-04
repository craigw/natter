require File.dirname(__FILE__) + '/../init'
include Crib

bot do
  username "user@domain.com"
  password "..."
  on :presence_change do |contact|
    puts "#{contact.jid} is now #{contact.status}. Their last known status was #{contact.previous_status}."
  end
end