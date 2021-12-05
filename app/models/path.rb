class Path < ApplicationRecord
  include AASM

  belongs_to :cloud_file

  enum status: %i[created downloaded errored failed]
  aasm column: :status, enum: true do
    state :created, intiial: true
    state :downloaded
    state :errored
    state :failed

    event :mark_downloaded do
      transitions from: %i[created failed], to: :downloaded
    end

    event :error do
      transitions from: %i[created errored], to: :errored
    end

    event :fail do
      transitions from: %i[created errored], to: :failed
    end
  end

  def content_type
    cloud_file.content_type&.to_sym
  end

  def server
    cloud_file.server
  end
end
