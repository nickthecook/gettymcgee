# frozen_string_literal: true

class SyncError < ApplicationRecord
  belongs_to :failable, polymorphic: true
end
