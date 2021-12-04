class CloudFile < ApplicationRecord
  include AASM

  class << self
    def from_object(obj)
      self.new(
        remote_id: obj.request_id,
        filename: obj.file_name,
        remote_status: obj.status,
        original_link: obj.original_link,
        directory: obj.is_directory,
        remote_created_at: obj.created_on
      )
    end
  end

  enum remote_status: %i[downloaded]
  enum status: %i[created pulled]

  aasm column: :status, enum: true do
    state :created, initial: true
    state :retrieved

    event :mark_retrieved do
      transitions from: :created, to: :retrieved
    end

    event :mark_not_retrieved do
      transitions from: :retrieved, to: :created
    end
  end
end
