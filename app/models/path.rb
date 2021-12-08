# frozen_string_literal: true

class Path < ApplicationRecord
  include AASM

  belongs_to :cloud_file

  enum status: %i[created downloading downloaded failed canceled]
  aasm column: :status, enum: true do
    state :created, intiial: true
    state :downloading
    state :downloaded
    state :errored
    state :failed
    state :canceled

    event :mark_downloading do
      transitions from: %i[created canceled failed], to: :downloading
    end

    event :mark_downloaded do
      transitions from: %i[created failed], to: :downloaded
    end

    event :fail do
      transitions from: %i[created errored], to: :failed
    end

    event :cancel do
      transitions from: :downloading, to: :canceled
    end
  end

  def content_type
    cloud_file.content_type&.to_sym
  end

  def server
    cloud_file.server
  end

  def percent_complete
    return 100 if downloaded?

    (amount.to_f / size * 100).to_i if size
  end

  def may_start_download?
    created? || canceled?
  end
end
