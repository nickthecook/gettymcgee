# frozen_string_literal: true

module Offcloud
  class File
    def initialize(data)
      @data = data.symbolize_keys
    end

    def method_missing(method_name, *_args, &_block)
      @data[method_name.to_s.camelcase(:lower).to_sym]
    end

    def respond_to?(method_name, include_private = false)
      return super if include_private

      true
    end

    def respond_to_missing?
      true
    end

    def to_h
      @data
    end
  end
end
