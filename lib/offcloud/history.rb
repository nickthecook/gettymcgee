# frozen_string_literal: true

module Offcloud
  class History < Offcloud::Response
    def files
      @files ||= body.map { |file_data| Offcloud::File.new(file_data) }
    end
  end
end
