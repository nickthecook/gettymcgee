# frozen_string_literal: true

class Path < ApplicationRecord
  SKIP_EXTENSTIONS = %w[txt aria2].freeze

  include AASM

  belongs_to :cloud_file

  enum status: %i[created downloading downloaded failed canceled enqueued]
  aasm column: :status, enum: true do
    state :created, intiial: true
    state :enqueued
    state :downloading
    state :downloaded
    state :errored
    state :failed
    state :canceled

    event :mark_downloading do
      transitions from: %i[created canceled failed enqueued], to: :downloading
    end

    event :mark_downloaded do
      transitions from: %i[downloading failed], to: :downloaded
    end

    event :fail do
      transitions from: %i[created errored], to: :failed
    end

    event :cancel do
      transitions from: %i[downloading enqueued], to: :canceled
    end

    event :mark_enqueued do
      transitions from: %i[created canceled], to: :enqueued
    end
  end

  def content_type
    cloud_file.content_type&.to_sym
  end

  def skip?
    SKIP_EXTENSTIONS.any? { |ext| path.match?(/\.#{ext}$/i) }
  end

  def downloadable?
    !skip?
  end

  def server
    cloud_file.server
  end

  def percent_complete
    return 100 if downloaded?

    (amount.to_f / size * 100).to_i if size
  end

  def may_start_download?
    created? || enqueued?
  end

  def may_enqueue_download?
    created? || canceled?
  end
end
