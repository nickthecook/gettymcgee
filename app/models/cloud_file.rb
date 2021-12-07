# frozen_string_literal: true

class CloudFile < ApplicationRecord
  VIDEO_EXTENSIONS = %w[mkv mp4 avi m4v webm].freeze
  ATTR_MAPPING = {
    file_name: :filename,
    is_directory: :directory,
    amount: :remote_amount
  }.freeze

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

  validates :remote_id, presence: true

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

  scope :downloaded_without_paths, -> { downloaded.where.missing(:paths) }

  def update_with_object(obj)
    attrs = map_keys(obj.to_h).slice(*attributes.symbolize_keys.keys)
    assign_attributes(attrs)

    self.content_type = CloudFile.type_for(obj.filename) if obj.filename
    update_status(obj.status) if obj.status

    save!
  end

  def remote_percent_complete
    return 100 if downloaded?

    (remote_amount.to_f / file_size * 100).to_i if file_size
  end

  def active?
    %i[created downloading].include?(status)
  end

  private

  def map_keys(input_hash)
    input_hash.transform_keys do |key|
      ATTR_MAPPING.include?(key) ? ATTR_MAPPING[key] : key
    end
  end

  def update_status(status)
    public_send(:"mark_#{status}") if respond_to?(:"may_mark_#{status}") && public_send(:"may_mark_#{status}?")
  end
end
