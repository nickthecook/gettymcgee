# frozen_string_literal: true

class OffcloudStatusUpdateService
  def initialize(cloud_file_id:)
    @cloud_file = CloudFile.find(cloud_file_id)
  end

  def execute
    @cloud_file.update_with_object(remote_status)
  end

  private

  def remote_status
    client.status(@cloud_file.remote_id)
  end

  def client
    @client ||= Offcloud::Client.new
  end
end
