# frozen_string_literal: true

require 'offcloud/response'
require 'offcloud/file'

module Offcloud
  class History < Offcloud::Response
    def files
      @files ||= begin
        body.map do |file_data|
          Offcloud::File.new(file_data)
        end
      end
    end
  end
end
