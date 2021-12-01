# frozen_string_literal: true

require 'offcloud/client'

class OffcloudFileFetcherService
  def execute
    files = client.fetch.files

    files.each do |file|
      cloud_file = CloudFile.from_object(file)
      next if CloudFile.find_by(remote_id: cloud_file.remote_id)

      cloud_file.save!
    end
  end

  private

  def client
    @client ||= Offcloud::Client.new
  end
end
