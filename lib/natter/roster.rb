module Natter
  class Roster < Hash
    def presence_change(contact)
      self[contact.id] ||= contact
      update(contact)
    end

    def update(contact)
      self[contact.id].status = contact.status
      self[contact.id].status_message = contact.status_message
    end
  end
end