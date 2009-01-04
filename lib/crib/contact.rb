module Crib
  class Contact
    include Doodle::Core
    has :status, :kind => Symbol, :default => :offline
    has :jid, :kind => String
    has :status_message, :kind => String, :default => ""
  end
end