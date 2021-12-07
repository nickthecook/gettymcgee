# frozen_string_literal: true

class OffcloudRemoveFileService
  def initialize(remote_id:)
    @remote_id = remote_id
  end

  def execute
    client.remove(@remote_id)
  end

  private

  def client
    @client ||= Offcloud::Client.new
  end
end
