module Natter
  class Contact
    include Doodle::Core
    has :status, :kind => Symbol, :default => :offline
    has :previous_status, :kind => Symbol, :default => :offline
    has :jid, :kind => String
    has :status_message, :kind => String, :default => "" do
      from NilClass do; ""; end
    end

    def online?
      [ :online ].include? status
    end
  end
end