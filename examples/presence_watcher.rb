require File.dirname(__FILE__) + '/../init'
include Crib

bot do
  username "user@domain.com"
  password "..."
  on :presence_change do |contact|
    puts "[#{Time.now}] #{contact.jid} changed presence to #{contact.status}."
  end
end