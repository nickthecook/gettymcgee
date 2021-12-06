# frozen_string_literal: true

class CloudFile < ApplicationRecord
  VIDEO_EXTENSIONS = %w[mkv mp4 avi m4v webm].freeze

  include AASM

  class << self
    def from_object(obj)
      new(
        remote_id: obj.request_id,
        filename: obj.file_name,
        status: obj.status,
        original_link: obj.original_link,
        directory: obj.is_directory,
        remote_created_at: obj.created_on,
        server: obj.server,
        content_type: type_for(obj.file_name)
      )
    end

    def type_for(filename)
      return nil unless filename
      return :tv if filename.match?(/s\d\de\d\d/i) || filename.match?(/season[ _.]?\d/i) || filename.match?(/s\d\d/i)

      :movie
    end
  end

  has_many :paths

  enum content_type: %i[tv movie]
  enum status: %i[downloaded downloading created deleted]

  aasm column: :status, enum: true do
    state :created, initial: true
    state :downloaded
    state :downloading
    state :deleted

    event :mark_deleted do
      transitions from: %i[created downloading downloaded], to: :deleted
    end

    event :mark_downloading do
      transitions from: :created, to: :downloading
    end

    event :mark_downloaded do
      transitions from: %i[created downloading], to: :downloaded
    end
  end

  def update_with_object(obj)
    update!(
      filename: obj.file_name,
      server: obj.server,
      content_type: CloudFile.type_for(obj.file_name),
      directory: obj.is_directory,
      remote_amount: obj.amount,
      file_size: obj.file_size
    )
    public_send(:"mark_#{obj.status}!") if public_send(:"may_mark_#{obj.status}?")
  end

  def remote_percent_complete
    (remote_amount.to_f / file_size * 100).to_i if file_size
  end
end
