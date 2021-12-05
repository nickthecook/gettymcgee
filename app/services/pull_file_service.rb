# frozen_string_literal: true

class PullFileService
  def initialize(cloud_file_id:)
    @cloud_file = CloudFile.find(cloud_file_id)
  end

  def execute
    client.pull(@cloud_file)
  end

  private

  def client
    @client ||= Offcloud::Client.new
  end
end
