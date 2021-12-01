# frozen_string_literal: true

require 'offcloud/client'

class OffcloudFileFetcherService
  def execute
    puts client.fetch
  end

  private

  def client
    @client ||= Offcloud::Client.new
  end
end
