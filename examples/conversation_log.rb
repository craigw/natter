require File.dirname(__FILE__) + '/../init'
include Natter

class TextFileConversationLog
  include Doodle::Core

  has :directory, :kind => String

  def message_received(message)
    File.open(history_file(message.sender), 'a+') do |f|
      log = "[#{message.received_at}] #{message.sender.jid} > #{message.body}"
      f.write(log)
      f.flush
    end
  end

  private
  def history_file(contact)
    "#{directory}/#{contact.jid.gsub(/\//, '_')}.log"
  end
end

bot do
  username "user@domain.com"
  password "..."
  history_store TextFileConversationLog(:directory => ".")
end