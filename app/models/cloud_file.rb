class CloudFile < ApplicationRecord
  include AASM

  class << self
    def from_object(obj)
      new(
        remote_id: obj.request_id,
        filename: obj.file_name,
        remote_status: obj.status,
        original_link: obj.original_link,
        directory: obj.is_directory,
        remote_created_at: obj.created_on,
        content_type: type_for(obj.file_name)
      )
    end

    def type_for(filename)
      return :tv if filename.match?(/s\d\de\d\d/i) || filename.match?(/season[ _.]?\d/i) || filename.match?(/s\d\d/i)

      :movie
    end
  end

  has_many :paths

  enum content_type: %i[tv movie]
  enum remote_status: %i[downloaded]
  enum status: %i[created pulled]

  aasm column: :status, enum: true do
    state :created, initial: true
    state :pulled

    event :mark_pulled do
      transitions from: :created, to: :pulled
    end

    event :mark_not_pulled do
      transitions from: :pulled, to: :created
    end
  end
end
