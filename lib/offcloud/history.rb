# frozen_string_literal: true

require 'offcloud/response'

module Offcloud
  class History < Offcloud::Response
    def files
      @files ||= begin
        data.map do |file_data|
          Offcloud::File.new(file_data)
        end
      end
    end
  end
end
