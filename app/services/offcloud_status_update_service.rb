# frozen_string_literal: true

class OffcloudStatusUpdateService
  def initialize(cloud_file_id:)
    @cloud_file = CloudFile.find(cloud_file_id)
  end

  def execute
    if remote_status
      @cloud_file.update_with_object(remote_status)
    elsif @cloud_file.may_mark_deleted?
      @cloud_file.mark_deleted!
    end
  end

  private

  def remote_status
    @remote_status ||= client.status(@cloud_file.remote_id)
  end

  def client
    @client ||= Offcloud::Client.new
  end
end
