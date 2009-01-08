require File.dirname(__FILE__) + '/../init'
include Natter

bot do
  channel do
    username "user@domain.com"
    password "..."
  end
  on :presence_change do |contact|
    puts "[#{Time.now}] #{contact.jid} changed presence to #{contact.status}."
  end
end