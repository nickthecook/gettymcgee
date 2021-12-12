# frozen_string_literal: true

module Failable
  extend ActiveSupport::Concern

  included do
    has_many :sync_errors, as: :failable
  end
end
