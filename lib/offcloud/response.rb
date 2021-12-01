# frozen_string_literal: true

module Offcloud
  class Response
    attr_reader :body

    def initialize(body)
      @body = body
    end
  end
end
