# frozen_string_literal: true

module Offcloud
  class Response
    def initialize(body)
      @body = body
    end

    def data
      @data ||= JSON.parse(@body)
    rescue JSON::ParserError
      STDERR.puts("Unable to parse response as JSON: #{@body}")
      {}
    end
  end
end
