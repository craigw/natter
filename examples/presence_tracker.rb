require File.dirname(__FILE__) + '/../init'
include Natter

bot do
  username "user@domain.com"
  password "..."
  on :presence_change do |contact|
    previous_status = (roster[contact.jid] && roster[contact.jid].status) || :unknown
    roster[contact.jid] ||= contact
    roster[contact.jid].status = contact.status
    puts "#{contact.jid} is now #{contact.status}. Their last known status was #{previous_status}."
  end
end